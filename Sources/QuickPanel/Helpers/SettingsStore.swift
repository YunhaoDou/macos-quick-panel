import SwiftUI

/// Settings storage via UserDefaults
final class SettingsStore: ObservableObject {
    static let shared = SettingsStore()

    private let defaults = UserDefaults.standard

    @Published var obsidianVaultPath: String {
        didSet { defaults.set(obsidianVaultPath, forKey: "obsidian_vault_path") }
    }

    @Published var launchAtLogin: Bool {
        didSet { applyLaunchAtLogin() }
    }

    @Published var appVersion: String = "1.1.1"

    private init() {
        // Load persisted settings
        let defaultVault = "\(NSHomeDirectory())/Library/Mobile Documents/iCloud~md~obsidian/Documents"
        obsidianVaultPath = defaults.string(forKey: "obsidian_vault_path") ?? defaultVault
        launchAtLogin = defaults.bool(forKey: "launch_at_login")
    }

    private func applyLaunchAtLogin() {
        guard let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.quickpanel.app")
                ?? Bundle.main.bundleURL as URL? else { return }

        if launchAtLogin {
            try? FileManager.default.setAttributes(
                [FileAttributeKey(rawValue: "NSURLIsUbiquitousItemKey"): false],
                ofItemAtPath: appURL.path
            )
            // Use LSSharedFileList for login items
            if let loginItemsRef = LSSharedFileListCreate(
                nil,
                kLSSharedFileListSessionLoginItems.takeRetainedValue(),
                nil
            )?.takeRetainedValue() {
                let iconRef = NSWorkspace.shared.icon(forFile: appURL.path)
                let item = LSSharedFileListInsertItemURL(
                    loginItemsRef,
                    kLSSharedFileListItemLast.takeRetainedValue(),
                    nil,
                    nil,
                    appURL as CFURL,
                    nil,
                    nil
                )
                if item != nil {
                    // Keep a reference to the icon ref so it's not deallocated
                    _ = iconRef
                }
            }
        } else {
            // Remove from login items
            if let loginItemsRef = LSSharedFileListCreate(
                nil,
                kLSSharedFileListSessionLoginItems.takeRetainedValue(),
                nil
            )?.takeRetainedValue() {
                let items = LSSharedFileListCopySnapshot(loginItemsRef, nil)?.takeRetainedValue() as! [LSSharedFileListItem]
                for item in items {
                    var outURL: Unmanaged<CFURL>?
                    if LSSharedFileListItemResolve(item, 0, &outURL, nil) == noErr,
                       let resolved = outURL?.takeRetainedValue() as URL?,
                       resolved.path == appURL.path {
                        LSSharedFileListItemRemove(loginItemsRef, item)
                    }
                }
            }
        }
    }

    /// Open system Login Items settings
    func openLoginItemSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.LoginItems-Settings.extension") {
            NSWorkspace.shared.open(url)
        }
    }
}
