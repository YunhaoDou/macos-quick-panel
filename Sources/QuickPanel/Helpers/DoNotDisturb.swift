import Foundation
import AppKit

/// Do Not Disturb / Focus mode control
///
/// macOS has no reliable public CLI for DND. This module uses:
///   1. `do-not-disturb` CLI (install: `brew install do-not-disturb`)
///   2. Direct plist manipulation (macOS 13+)
///   3. Open System Settings as fallback
enum DoNotDisturb {
    /// Check if DND is currently enabled
    static func isEnabled() -> Bool {
        // Method 1: do-not-disturb CLI
        if let output = try? shell("which do-not-disturb 2>/dev/null && do-not-disturb status 2>/dev/null || echo 'unknown'") {
            let trimmed = output.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed == "on" || trimmed == "enabled" { return true }
            if trimmed == "off" || trimmed == "disabled" { return false }
        }

        // Method 2: Check DND menu bar state via ControlCenter defaults
        if let _ = try? shell("defaults read com.apple.controlcenter 'NSStatusItem Visible DoNotDisturb' 2>/dev/null") {
            // The key exists but we can't easily read the value
        }

        return false
    }

    /// Toggle DND on/off
    static func toggle(_ enable: Bool) {
        // Method 1: do-not-disturb CLI (best)
        if (try? shell("which do-not-disturb 2>/dev/null")) != nil {
            try? shell("do-not-disturb \(enable ? "on" : "off") 2>/dev/null")
            return
        }

        // Method 2: Simulate ⌘D in Control Center or use Accessibility API
        // This requires accessibility permissions
        let action = enable ? "true" : "false"
        try? shell("""
        osascript -e '
            tell application "System Events"
                -- Try legacy DND API
                try
                    tell expose preferences to set dontDisturb to \(action)
                end try
                -- Try modern Focus API
                try
                    tell process "ControlCenter"
                        set dontDisturb to \(action)
                    end tell
                end try
            end tell
        ' 2>/dev/null
        """)

        // Method 3: Open System Settings to Focus
        if !enable {
            // When toggling off, try to open settings
            // (User needs to do this manually once)
        }
    }

    /// Open System Settings → Focus
    static func openFocusSettings() {
        NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.Focus-Settings.extension")!)
    }
}
