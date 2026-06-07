import Foundation
import AppKit

/// Toggle hidden files visibility in Finder
enum FinderHiddenFilesManager {
    static var isShowingHidden: Bool {
        let current = try? shell("defaults read com.apple.finder AppleShowAllFiles 2>/dev/null || echo 'false'")
        return current?.trimmingCharacters(in: .whitespacesAndNewlines) == "true"
    }

    static func toggle() {
        let newValue = isShowingHidden ? "false" : "true"
        try? shell("defaults write com.apple.finder AppleShowAllFiles -bool \(newValue)")
        try? shell("killall Finder")
    }
}
