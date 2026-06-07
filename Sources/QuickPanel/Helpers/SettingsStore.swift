import Foundation
import AppKit

/// 持久化存储用户偏好设置
final class SettingsStore: ObservableObject {
    static let shared = SettingsStore()

    @Published var obsidianVaultPath: String {
        didSet { UserDefaults.standard.set(obsidianVaultPath, forKey: "obsidian_vault_path") }
    }
    @Published var pomodoroWorkMinutes: Double {
        didSet { UserDefaults.standard.set(pomodoroWorkMinutes, forKey: "pomodoro_work_minutes") }
    }
    @Published var pomodoroBreakMinutes: Double {
        didSet { UserDefaults.standard.set(pomodoroBreakMinutes, forKey: "pomodoro_break_minutes") }
    }
    @Published var clipboardMaxItems: Double {
        didSet { UserDefaults.standard.set(Int(clipboardMaxItems), forKey: "clipboard_max_items") }
    }
    @Published var launchAtLogin: Bool {
        didSet {
            UserDefaults.standard.set(launchAtLogin, forKey: "launch_at_login")
            applyLaunchAtLogin()
        }
    }
    @Published var shortcutKeyCode: Int {
        didSet { UserDefaults.standard.set(shortcutKeyCode, forKey: "shortcut_key_code") }
    }
    @Published var shortcutModifiers: Int {
        didSet { UserDefaults.standard.set(shortcutModifiers, forKey: "shortcut_modifiers") }
    }

    private init() {
        let defaults = UserDefaults.standard

        let home = NSHomeDirectory()
        obsidianVaultPath = defaults.string(forKey: "obsidian_vault_path")
            ?? "\(home)/Library/Mobile Documents/iCloud~md~obsidian/Documents"
        pomodoroWorkMinutes = defaults.object(forKey: "pomodoro_work_minutes") as? Double ?? 25
        pomodoroBreakMinutes = defaults.object(forKey: "pomodoro_break_minutes") as? Double ?? 5
        clipboardMaxItems = Double(defaults.object(forKey: "clipboard_max_items") as? Int ?? 20)
        launchAtLogin = defaults.object(forKey: "launch_at_login") as? Bool ?? false
        shortcutKeyCode = defaults.object(forKey: "shortcut_key_code") as? Int ?? 12
        shortcutModifiers = defaults.object(forKey: "shortcut_modifiers") as? Int ?? (Int(cmdKey) + Int(optionKey))
    }

    private func applyLaunchAtLogin() {
        guard let appURL = NSWorkspace.shared.urlForApplication(
            withBundleIdentifier: Bundle.main.bundleIdentifier ?? "com.quickpanel.app"
        ) ?? Bundle.main.bundleURL as URL? else { return }

        if launchAtLogin {
            try? appURL.setResourceValue(true, forKey: .isUbiquitousItem)
        }
        // Use LSSharedFileList for login items
        if let loginItemsRef = LSSharedFileListCreate(
            nil,
            kLSSharedFileListSessionLoginItems,
            nil
        )?.takeRetainedValue() {
            let loginItems = LSSharedFileListCopySnapshot(loginItemsRef, nil)?.takeRetainedValue() as! [LSSharedFileListItem]
            if launchAtLogin {
                let alreadyExists = loginItems.contains { item in
                    guard let urlRef = LSSharedFileListItemCopyResolvedURL(item, 0, nil)?.takeRetainedValue() else { return false }
                    return (urlRef as URL).path == appURL.path
                }
                if !alreadyExists {
                    LSSharedFileListInsertItemURL(
                        loginItemsRef,
                        kLSSharedFileListItemLast,
                        nil,
                        nil,
                        appURL as CFURL,
                        nil,
                        nil
                    )
                }
            } else {
                for item in loginItems {
                    guard let urlRef = LSSharedFileListItemCopyResolvedURL(item, 0, nil)?.takeRetainedValue() else { continue }
                    if (urlRef as URL).path == appURL.path {
                        LSSharedFileListItemRemove(loginItemsRef, item)
                    }
                }
            }
        }
    }

    /// 获取设置中的 Obsidian 路径
    var resolvedObsidianPath: String {
        let path = obsidianVaultPath
        if path.hasPrefix("~") {
            return path.replacingOccurrences(of: "~", with: NSHomeDirectory())
        }
        return path
    }
}

/// 快捷键显示文本
extension SettingsStore {
    var shortcutDisplayText: String {
        var parts: [String] = []
        if shortcutModifiers & Int(cmdKey) != 0 { parts.append("⌘") }
        if shortcutModifiers & Int(optionKey) != 0 { parts.append("⌥") }
        if shortcutModifiers & Int(shiftKey) != 0 { parts.append("⇧") }
        if shortcutModifiers & Int(controlKey) != 0 { parts.append("⌃") }

        // Map keyCode to display
        let keyMap: [Int: String] = [
            0: "A", 1: "S", 2: "D", 3: "F", 4: "H", 5: "G",
            6: "Z", 7: "X", 8: "C", 9: "V", 11: "B", 12: "Q",
            13: "W", 14: "E", 15: "R", 16: "Y", 17: "T",
            18: "1", 19: "2", 20: "3", 21: "4", 22: "5",
            23: "6", 24: "7", 25: "8", 26: "9", 27: "0",
            28: "-", 29: "=", 30: "Delete", 31: "Tab",
            32: "O", 33: "U", 34: "[", 35: "]", 36: "Return",
            37: "L", 38: "J", 39: ":", 40: "'", 41: "`",
            42: "⇧", 43: "\\", 44: "I", 45: "P", 46: "]",
            47: "[", 48: "Space", 49: "Space", 50: "M",
            51: ";", 52: "'", 53: "`", 54: ",", 55: ".",
            56: "/", 57: "⇪", 58: "F1", 59: "F2", 60: "F3",
            61: "F4", 62: "F5", 63: "F6", 64: "F7", 65: "F8",
            66: "F9", 67: "F10", 68: "F11", 69: "F12"
        ]
        parts.append(keyMap[shortcutKeyCode] ?? "Q")
        return parts.joined()
    }
}
