import Foundation
import AppKit

/// Screenshot modes
enum ScreenshotMode {
    case region, window, fullscreen, clipboard
}

/// Window layout options
enum WindowLayout {
    case left, right, maximize, center
}

/// Screenshot tools: region, window, fullscreen
enum ScreenshotManager {
    static func captureRegion() {
        let path = "~/Desktop/截图_$(date +%Y-%m-%d_%H.%M.%S).png"
        try? shell("screencapture -i '\(path)'")
    }

    static func captureWindow() {
        let path = "~/Desktop/截图_$(date +%Y-%m-%d_%H.%M.%S).png"
        try? shell("screencapture -iw '\(path)'")
    }

    static func captureFullscreen() {
        let path = "~/Desktop/截图_$(date +%Y-%m-%d_%H.%M.%S).png"
        try? shell("screencapture '\(path)'")
    }

    static func captureToClipboard() {
        try? shell("screencapture -c")
    }
}

/// Window layout management via AppleScript
enum WindowManager {
    private static let script: String = """
    tell application "System Events"
        set frontApp to name of first application process whose frontmost is true
    end tell
    tell application frontApp
        %@
    end tell
    """

    static func tileLeft()   { run("set bounds of window 1 to {0, 40, 720, 1080}") }
    static func tileRight()  { run("set bounds of window 1 to {720, 40, 1440, 1080}") }
    static func maximize()   { run("set bounds of window 1 to {0, 40, 1440, 1080}") }
    static func center()     { run("set bounds of window 1 to {144, 148, 1296, 972}") }

    private static func run(_ action: String) {
        let full = script.replacingOccurrences(of: "%@", with: action)
        try? shell("osascript -e '\(full)'")
    }
}
