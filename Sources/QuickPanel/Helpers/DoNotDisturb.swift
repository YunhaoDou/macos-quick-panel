import Foundation

/// Do Not Disturb toggle using AppleScript / macOS APIs
enum DoNotDisturb {
    static func toggle(_ enable: Bool) {
        if enable {
            // Turn on DND via AppleScript
            try? shell("""
            osascript -e 'tell application "System Events" to tell expose preferences to set dontDisturb to true'
            """)
            // Alternative: use do-not-disturb CLI if available
            if (try? shell("which do-not-disturb")) != nil {
                try? shell("do-not-disturb on")
            }
        } else {
            try? shell("""
            osascript -e 'tell application "System Events" to tell expose preferences to set dontDisturb to false'
            """)
            if (try? shell("which do-not-disturb")) != nil {
                try? shell("do-not-disturb off")
            }
        }
    }
}
