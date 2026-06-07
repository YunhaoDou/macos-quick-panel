import Foundation
import AppKit

/// Toggle desktop icon visibility
enum DesktopIconsManager {
    static var isHidden: Bool {
        let current = try? shell("defaults read com.apple.finder CreateDesktop 2>/dev/null || echo 'true'")
        return current?.trimmingCharacters(in: .whitespacesAndNewlines) == "false"
    }

    static func toggle() {
        let newValue: String
        if isHidden {
            newValue = "true"  // Show icons
        } else {
            newValue = "false" // Hide icons
        }
        try? shell("defaults write com.apple.finder CreateDesktop -bool \(newValue)")
        try? shell("killall Finder")
    }
}
