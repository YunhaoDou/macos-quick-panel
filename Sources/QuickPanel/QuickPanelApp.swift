import SwiftUI

@main
struct QuickPanelApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        MenuBarExtra("QuickPanel", systemImage: appState.menuIcon) {
            MenuBarContentView()
                .environmentObject(appState)
        }
        .menuBarExtraStyle(.window)
    }
}

@MainActor
class AppState: ObservableObject {
    // ── System ──
    @Published var isDarkMode: Bool {
        didSet { applyDarkMode() }
    }
    @Published var isDNDEnabled: Bool = false

    // ── Audio ──
    @Published var audioDevices: [AudioDevice] = []
    @Published var selectedAudioDevice: String = ""

    // ── Clipboard ──
    @Published var clipboardHistory: [String] = []

    // ── Input Method ──
    @Published var inputMethodLabel: String = "英"

    // ── Desktop Icons ──
    @Published var desktopIconsHidden: Bool = false

    // ── Shortcuts ──
    @Published var preferredShortcut: String = "⌥⌘Q"

    // ── Feedback ──
    @Published var feedbackText: String = ""
    @Published var showFeedback: Bool = false

    // ── Updater ──
    @Published var updater = AppUpdater.shared

    // ── Internal ──
    private var clipboardTimer: Timer?

    var menuIcon: String { "square.grid.2x2" }

    init() {
        // Read initial states
        let currentMode = try? SystemCommands.currentInterfaceStyle()
        self.isDarkMode = (currentMode == "Dark")
        self.audioDevices = AudioManager.shared.listDevices()
        self.selectedAudioDevice = AudioManager.shared.currentDeviceName()
        self.inputMethodLabel = InputMethodManager.currentShortName()
        self.desktopIconsHidden = DesktopIconsManager.isHidden
        self.clipboardHistory = ClipboardManager.shared.recentItems

        // Read DND state (macOS 14+)
        checkDNDState()

        // Start clipboard polling (every 1.5s)
        startClipboardPolling()

        // Register global shortcut
        setupHotkey()
    }

    // MARK: - Clipboard Polling

    private func startClipboardPolling() {
        clipboardTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                ClipboardManager.shared.poll()
                self?.clipboardHistory = ClipboardManager.shared.recentItems
            }
        }
    }

    // MARK: - DND

    private func checkDNDState() {
        // Attempt to read DND state via AppleScript
        if let result = try? shell("""
            osascript -e 'tell application "System Events" to tell expose preferences to get dontDisturb' 2>/dev/null || echo "false"
            """) {
            isDNDEnabled = result.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "true"
        }
    }

    func toggleDND() {
        isDNDEnabled.toggle()
        DoNotDisturb.toggle(isDNDEnabled)
        showTempFeedback(isDNDEnabled ? "勿扰已开启" : "勿扰已关闭")
    }

    // MARK: - Dark Mode

    private func applyDarkMode() {
        SystemCommands.toggleDarkMode(isDarkMode)
        showTempFeedback(isDarkMode ? "深色模式" : "浅色模式")
    }

    // MARK: - Lock

    func lockScreen() {
        SystemCommands.lockScreen()
        showTempFeedback("已锁定")
    }

    // MARK: - Trash

    func emptyTrash() {
        SystemCommands.emptyTrash()
        showTempFeedback("废纸篓已清空")
    }

    // MARK: - Audio

    func refreshAudioDevices() {
        audioDevices = AudioManager.shared.listDevices()
        selectedAudioDevice = AudioManager.shared.currentDeviceName()
    }

    func switchAudio(to deviceName: String) {
        AudioManager.shared.switchToDevice(named: deviceName)
        selectedAudioDevice = deviceName
        showTempFeedback("音频: \(deviceName)")
    }

    // MARK: - Input Method

    func toggleInputMethod() {
        InputMethodManager.toggleChineseEnglish()
        let label = InputMethodManager.currentShortName()
        inputMethodLabel = label
        showTempFeedback(label == "中" ? "已切换中文" : "已切换英文")
    }

    // MARK: - Desktop Icons

    func toggleDesktopIcons() {
        DesktopIconsManager.toggle()
        desktopIconsHidden = DesktopIconsManager.isHidden
        showTempFeedback(desktopIconsHidden ? "桌面图标已隐藏" : "桌面图标已显示")
    }

    // MARK: - Macros

    func activateMacro(_ macro: MacroPreset) {
        MacroRunner.run(macro)
        let names: [MacroPreset: String] = [.work: "工作模式", .night: "深夜模式", .presentation: "演示模式", .leaving: "出门模式"]
        showTempFeedback("\(names[macro] ?? "") 已启动")
    }

    // MARK: - Pomodoro

    func pomodoroCompleted() {
        // Play system notification sound
        NSSound.beep()
        showTempFeedback("🍅 番茄时间到！")
        // Show a notification
        let notification = NSUserNotification()
        notification.title = "番茄钟"
        notification.informativeText = "专注时间结束，休息一下吧！"
        notification.soundName = nil
        NSUserNotificationCenter.default.deliver(notification)
    }

    // MARK: - Hotkey

    private func setupHotkey() {
        HotkeyManager.shared.register { [weak self] in
            DispatchQueue.main.async {
                self?.showTempFeedback("⌥⌘Q QuickPanel")
                // Bring app to front (as much as a MenuBarExtra can)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }

    // MARK: - Feedback Toast

    private func showTempFeedback(_ text: String) {
        feedbackText = text
        withAnimation(.easeInOut(duration: 0.15)) { showFeedback = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            withAnimation(.easeInOut(duration: 0.3)) { self?.showFeedback = false }
        }
    }
}
