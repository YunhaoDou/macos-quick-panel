import Foundation
import AppKit

/// Window layout management via AppleScript
enum WindowManager {
    /// Resize frontmost window to left half
    static func tileLeft() {
        try? shell("""
        osascript -e '
            tell application "System Events"
                set frontApp to name of first application process whose frontmost is true
            end tell
            tell application frontApp
                set bounds of window 1 to {0, 40, 720, 1080}
            end tell
        '
        """)
    }

    /// Resize frontmost window to right half
    static func tileRight() {
        try? shell("""
        osascript -e '
            tell application "System Events"
                set frontApp to name of first application process whose frontmost is true
            end tell
            tell application frontApp
                set bounds of window 1 to {720, 40, 1440, 1080}
            end tell
        '
        """)
    }

    /// Maximize frontmost window
    static func maximize() {
        try? shell("""
        osascript -e '
            tell application "System Events"
                set frontApp to name of first application process whose frontmost is true
            end tell
            tell application frontApp
                set bounds of window 1 to {0, 40, 1440, 1080}
            end tell
        '
        """)
    }

    /// Center frontmost window (80% of screen size)
    static func center() {
        try? shell("""
        osascript -e '
            tell application "System Events"
                set frontApp to name of first application process whose frontmost is true
            end tell
            tell application frontApp
                set bounds of window 1 to {144, 148, 1296, 972}
            end tell
        '
        """)
    }
}
