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
    @Published var clipboardHistory: [String] = ClipboardManager.shared.recentItems

    // ── Input Method ──
    @Published var inputMethodLabel: String = "英"

    // ── Desktop Icons ──
    @Published var desktopIconsHidden: Bool = DesktopIconsManager.isHidden

    // ── Shortcuts ──
    @Published var preferredShortcut: String = "⌥⌘Q" {
        didSet { updateShortcut() }
    }

    var menuIcon: String { "square.grid.2x2" }

    init() {
        let currentMode = try? SystemCommands.currentInterfaceStyle()
        self.isDarkMode = (currentMode == "Dark")
        self.audioDevices = AudioManager.shared.listDevices()
        self.selectedAudioDevice = AudioManager.shared.currentDeviceName()
        self.inputMethodLabel = InputMethodManager.currentShortName()

        // Register global shortcut
        setupHotkey()
    }

    // MARK: - Dark Mode

    private func applyDarkMode() {
        SystemCommands.toggleDarkMode(isDarkMode)
    }

    // MARK: - DND

    func toggleDND() {
        isDNDEnabled.toggle()
        DoNotDisturb.toggle(isDNDEnabled)
    }

    // MARK: - Lock

    func lockScreen() {
        SystemCommands.lockScreen()
    }

    // MARK: - Trash

    func emptyTrash() {
        SystemCommands.emptyTrash()
    }

    // MARK: - Audio

    func refreshAudioDevices() {
        audioDevices = AudioManager.shared.listDevices()
        selectedAudioDevice = AudioManager.shared.currentDeviceName()
    }

    func switchAudio(to deviceName: String) {
        AudioManager.shared.switchToDevice(named: deviceName)
        selectedAudioDevice = deviceName
    }

    // MARK: - Macros

    func activateMacro(_ macro: MacroPreset) {
        MacroRunner.run(macro)
    }

    // MARK: - Input Method

    func toggleInputMethod() {
        InputMethodManager.toggleChineseEnglish()
        inputMethodLabel = InputMethodManager.currentShortName()
    }

    // MARK: - Desktop Icons

    func toggleDesktopIcons() {
        DesktopIconsManager.toggle()
        desktopIconsHidden = DesktopIconsManager.isHidden
    }

    // MARK: - Hotkey

    private func setupHotkey() {
        // The hotkey handler will toggle the app or show menu
        // For now, it's registered but the callback will be set from the view
    }

    private func updateShortcut() {
        // Re-register with new shortcut
    }
}
