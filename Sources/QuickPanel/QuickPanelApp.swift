import SwiftUI
import Carbon

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
    // ── Clipboard ──
    @Published var clipboardHistory: [String] = []

    // ── Input Method ──
    @Published var inputMethodLabel: String = "英"

    // ── Desktop Icons ──
    @Published var desktopIconsHidden: Bool = false

    // ── Caffeinate ──
    @Published var caffeinateManager = CaffeinateManager.shared

    // ── Hidden Files ──
    @Published var hiddenFilesShown: Bool = false

    // ── Shortcuts ──
    @Published var preferredShortcut: String = "⌥⌘P"

    // ── Feedback ──
    @Published var feedbackText: String = ""
    @Published var showFeedback: Bool = false

    // ── Updater ──
    @Published var updater = AppUpdater.shared

    // ── Internal ──
    private var clipboardTimer: Timer?

    var menuIcon: String { "square.grid.2x2" }

    init() {
        self.inputMethodLabel = InputMethodManager.currentShortName()
        self.desktopIconsHidden = DesktopIconsManager.isHidden
        self.hiddenFilesShown = FinderHiddenFilesManager.isShowingHidden
        self.clipboardHistory = ClipboardManager.shared.recentItems

        // Setup main panel
        PanelManager.shared.setup(with: self)

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

    // MARK: - Screenshot

    func screenshot(_ mode: ScreenshotMode) {
        switch mode {
        case .region: ScreenshotManager.captureRegion()
        case .window: ScreenshotManager.captureWindow()
        case .fullscreen: ScreenshotManager.captureFullscreen()
        case .clipboard: ScreenshotManager.captureToClipboard()
        }
        let names: [ScreenshotMode: String] = [.region: "区域截图", .window: "窗口截图", .fullscreen: "全屏截图", .clipboard: "截图到剪贴板"]
        showTempFeedback(names[mode] ?? "截图完成")
    }

    // MARK: - Window Layout

    func tileWindow(_ layout: WindowLayout) {
        switch layout {
        case .left: WindowManager.tileLeft()
        case .right: WindowManager.tileRight()
        case .maximize: WindowManager.maximize()
        case .center: WindowManager.center()
        }
        let names: [WindowLayout: String] = [.left: "窗口左半", .right: "窗口右半", .maximize: "窗口最大化", .center: "窗口居中"]
        showTempFeedback(names[layout] ?? "窗口调整完成")
    }

    // MARK: - Caffeinate

    func toggleCaffeinate() {
        caffeinateManager.toggle()
        showTempFeedback(caffeinateManager.isActive ? "阻止休眠已开启" : "阻止休眠已关闭")
    }

    // MARK: - Hidden Files

    func toggleHiddenFiles() {
        FinderHiddenFilesManager.toggle()
        hiddenFilesShown = FinderHiddenFilesManager.isShowingHidden
        showTempFeedback(hiddenFilesShown ? "隐藏文件已显示" : "隐藏文件已隐藏")
    }

    // MARK: - Clear Clipboard

    func clearClipboard() {
        NSPasteboard.general.clearContents()
        // Also clear our history
        ClipboardManager.shared.clear()
        clipboardHistory = []
        showTempFeedback("剪贴板已清空")
    }

    // MARK: - Macros

    func activateMacro(_ macro: MacroPreset) {
        MacroRunner.run(macro)
        let names: [MacroPreset: String] = [.work: "工作模式", .night: "深夜模式", .presentation: "演示模式", .leaving: "出门模式"]
        showTempFeedback("\(names[macro] ?? "") 已启动")
    }

    // MARK: - Pomodoro

    func pomodoroCompleted() {
        NSSound.beep()
        showTempFeedback("🍅 番茄时间到！")
        let notification = NSUserNotification()
        notification.title = "番茄钟"
        notification.informativeText = "专注时间结束，休息一下吧！"
        notification.soundName = nil
        NSUserNotificationCenter.default.deliver(notification)
    }

    // MARK: - Hotkey

    private func setupHotkey() {
        HotkeyManager.shared.register(combo: (35, UInt32(cmdKey + optionKey))) { [weak self] in
            DispatchQueue.main.async {
                PanelManager.shared.toggle()
            }
        }
    }

    // MARK: - Feedback Toast

    func showTempFeedback(_ text: String) {
        feedbackText = text
        withAnimation(.easeInOut(duration: 0.15)) { showFeedback = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            withAnimation(.easeInOut(duration: 0.3)) { self?.showFeedback = false }
        }
    }
}
