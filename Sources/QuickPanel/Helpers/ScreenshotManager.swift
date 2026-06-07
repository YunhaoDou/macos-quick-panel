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
        // Interactive region selection
        try? shell("screencapture -i ~/Desktop/截图\\ $(date +'%Y-%m-%d\\ %H.%M.%S').png")
    }

    static func captureWindow() {
        // Click a window to capture it
        try? shell("screencapture -iw ~/Desktop/截图\\ $(date +'%Y-%m-%d\\ %H.%M.%S').png")
    }

    static func captureFullscreen() {
        // Capture entire screen(s)
        try? shell("screencapture -T 0 ~/Desktop/截图\\ $(date +'%Y-%m-%d\\ %H.%M.%S').png")
    }

    static func captureToClipboard() {
        // Capture to clipboard instead of file
        try? shell("screencapture -c")
    }
}
