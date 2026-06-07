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
    @Published var isDarkMode: Bool {
        didSet { applyDarkMode() }
    }
    @Published var isDNDEnabled: Bool = false
    @Published var clipboardHistory: [String] = ClipboardManager.shared.recentItems
    @Published var audioDevices: [AudioDevice] = []
    @Published var selectedAudioDevice: String = ""

    var menuIcon: String {
        "square.grid.2x2"
    }

    init() {
        // Read current dark mode state
        let currentMode = try? SystemCommands.currentInterfaceStyle()
        self.isDarkMode = (currentMode == "Dark")
        self.audioDevices = AudioManager.shared.listDevices()
        self.selectedAudioDevice = AudioManager.shared.currentDeviceName()
    }

    private func applyDarkMode() {
        SystemCommands.toggleDarkMode(isDarkMode)
    }

    func toggleDND() {
        isDNDEnabled.toggle()
        DoNotDisturb.toggle(isDNDEnabled)
    }

    func lockScreen() {
        SystemCommands.lockScreen()
    }

    func emptyTrash() {
        SystemCommands.emptyTrash()
    }

    func refreshAudioDevices() {
        audioDevices = AudioManager.shared.listDevices()
        selectedAudioDevice = AudioManager.shared.currentDeviceName()
    }

    func switchAudio(to deviceName: String) {
        AudioManager.shared.switchToDevice(named: deviceName)
        selectedAudioDevice = deviceName
    }

    func activateMacro(_ macro: MacroPreset) {
        MacroRunner.run(macro)
    }
}
