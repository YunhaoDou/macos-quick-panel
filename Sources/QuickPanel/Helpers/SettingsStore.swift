import SwiftUI
import ServiceManagement

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
        let defaultVault = FileManager.default.fileExists(atPath: "\(NSHomeDirectory())/Library/Mobile Documents/iCloud~md~obsidian/Documents")
            ? "\(NSHomeDirectory())/Library/Mobile Documents/iCloud~md~obsidian/Documents"
            : "\(NSHomeDirectory())/Documents"

        obsidianVaultPath = defaults.string(forKey: "obsidian_vault_path") ?? defaultVault
        launchAtLogin = defaults.bool(forKey: "launch_at_login")

        // Sync actual login state on init
        if #available(macOS 13.0, *) {
            launchAtLogin = SMAppService.mainApp.status == .enabled
        }
    }

    private func applyLaunchAtLogin() {
        if #available(macOS 13.0, *) {
            do {
                if launchAtLogin {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                // Fallback to old method
                legacyToggleLoginItem(enable: launchAtLogin)
            }
        } else {
            legacyToggleLoginItem(enable: launchAtLogin)
        }
        defaults.set(launchAtLogin, forKey: "launch_at_login")
    }

    private func legacyToggleLoginItem(enable: Bool) {
        let appURL = Bundle.main.bundleURL

        if enable {
            guard let loginItemsRef = LSSharedFileListCreate(
                nil,
                kLSSharedFileListSessionLoginItems.takeRetainedValue(),
                nil
            )?.takeRetainedValue() else { return }

            LSSharedFileListInsertItemURL(
                loginItemsRef,
                kLSSharedFileListItemLast.takeRetainedValue(),
                nil,
                nil,
                appURL as CFURL,
                nil,
                nil
            )
        } else {
            guard let loginItemsRef = LSSharedFileListCreate(
                nil,
                kLSSharedFileListSessionLoginItems.takeRetainedValue(),
                nil
            )?.takeRetainedValue() else { return }

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
