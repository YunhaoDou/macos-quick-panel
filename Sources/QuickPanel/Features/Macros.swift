import Foundation
import AppKit

/// Preset macros — one-click multi-action profiles
enum MacroPreset: String, CaseIterable {
    case work        // 工作模式
    case night       // 深夜模式
    case presentation // 演示模式
    case leaving     // 出门模式
}

/// Executes macro presets
enum MacroRunner {
    static func run(_ preset: MacroPreset) {
        switch preset {
        case .work:
            activateWorkMode()
        case .night:
            activateNightMode()
        case .presentation:
            activatePresentationMode()
        case .leaving:
            activateLeavingMode()
        }
    }

    private static func activateWorkMode() {
        // Open common work apps
        let apps = ["Visual Studio Code", "Google Chrome", "Terminal"]
        for app in apps {
            try? shell("open -a '\(app)'")
        }
    }

    private static func activateNightMode() {
        // Low volume, close distracting apps
        try? shell("osascript -e 'set volume output volume 20'")
        // Close distracting apps
        try? shell("killall 'Messages' 2>/dev/null")
        try? shell("killall 'Mail' 2>/dev/null")
    }

    private static func activatePresentationMode() {
        // Hide desktop icons
        try? shell("defaults write com.apple.finder CreateDesktop false && killall Finder")
    }

    private static func activateLeavingMode() {
        // Lock screen + empty trash + close apps
        try? shell("rm -rfv ~/.Trash/* 2>/dev/null")
        // Ask active apps to quit gracefully
        try? shell("osascript -e 'tell application \"Visual Studio Code\" to quit' 2>/dev/null")
        try? shell("osascript -e 'tell application \"Google Chrome\" to quit' 2>/dev/null")
        // Lock
        try? shell("open -a ScreenSaverEngine")
        try? shell("pmset displaysleepnow")
    }
}
