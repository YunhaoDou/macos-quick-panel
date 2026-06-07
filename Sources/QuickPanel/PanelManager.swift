import SwiftUI
import AppKit

/// Manages the floating main panel window
final class PanelManager: ObservableObject {
    static let shared = PanelManager()

    private var panel: NSPanel?
    private weak var appState: AppState?

    private init() {}

    func setup(with appState: AppState) {
        self.appState = appState
    }

    var isVisible: Bool {
        panel?.isVisible ?? false
    }

    func toggle() {
        if isVisible {
            hide()
        } else {
            show()
        }
    }

    func show() {
        if panel == nil {
            createPanel()
        }
        panel?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func hide() {
        panel?.close()
    }

    private func createPanel() {
        guard let appState = appState else { return }

        panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 320, height: 580),
            styleMask: [.titled, .closable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        panel?.titlebarAppearsTransparent = true
        panel?.titleVisibility = .hidden
        panel?.isMovableByWindowBackground = true
        panel?.hasShadow = true
        panel?.level = .floating
        panel?.isReleasedWhenClosed = false
        panel?.hidesOnDeactivate = false

        // Restore last position
        if let savedFrame = UserDefaults.standard.string(forKey: "panel_frame") {
            panel?.setFrame(NSRectFromString(savedFrame), display: true)
        } else {
            // Center on screen
            panel?.center()
        }

        let contentView = MainPanelView()
            .environmentObject(appState)
            .modifier(GlassBackground())

        panel?.contentView = NSHostingView(rootView: contentView)
        panel?.contentView?.frame = NSRect(x: 0, y: 0, width: 320, height: 580)

        // Save position on move
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(savePanelFrame),
            name: NSWindow.didMoveNotification,
            object: panel
        )
    }

    @objc private func savePanelFrame() {
        guard let frame = panel?.frame else { return }
        UserDefaults.standard.set(NSStringFromRect(frame), forKey: "panel_frame")
    }
}

/// Main panel content view (full version)
struct MainPanelView: View {
    @EnvironmentObject private var state: AppState
    @State private var showPomodoro = false
    @State private var showClipboard = false
    @State private var showNoteEditor = false
    @State private var showPreferences = false
    @State private var noteContent = ""

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "square.grid.2x2")
                    .foregroundColor(.accentColor)
                Text("QuickPanel")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                if state.showFeedback {
                    Text(state.feedbackText)
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.accentColor.opacity(0.8))
                        .cornerRadius(4)
                        .transition(.opacity)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider().opacity(0.3)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // 快捷操作
                    sectionHeader("快捷操作")
                    panelLockRow
                    panelTrashRow
                    panelNoteRow
                    panelPomodoroRow
                    panelClipboardRow

                    if showPomodoro {
                        Divider().opacity(0.3).padding(.vertical, 4)
                        PomodoroView()
                            .padding(.horizontal, 8)
                    }
                    if showClipboard {
                        Divider().opacity(0.3).padding(.vertical, 4)
                        ClipboardHistoryView(items: state.clipboardHistory)
                    }

                    Divider().opacity(0.3).padding(.vertical, 4)

                    // 输入 & 桌面
                    sectionHeader("输入 & 桌面")
                    panelInputRow
                    panelDesktopRow

                    Divider().opacity(0.3).padding(.vertical, 4)

                    // 截图
                    sectionHeader("截图")
                    panelScreenshotRow

                    Divider().opacity(0.3).padding(.vertical, 4)

                    // 窗口布局
                    sectionHeader("窗口布局")
                    panelWindowRow

                    Divider().opacity(0.3).padding(.vertical, 4)

                    // 系统工具
                    sectionHeader("系统工具")
                    panelCaffeinateRow
                    panelHiddenRow

                    Divider().opacity(0.3).padding(.vertical, 4)

                    // 一键场景
                    sectionHeader("一键场景")
                    panelMacroRow
                }
            }

            Divider().opacity(0.3)

            // Footer
            HStack {
                Button(action: { showPreferences = true }) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 11))
                    Text("偏好设置")
                        .font(.caption)
                }
                .buttonStyle(.plain)
                .foregroundColor(.secondary)
                Spacer()
                Text("⌥⌘P")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.secondary.opacity(0.5))
                Text("隐藏")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .onTapGesture { PanelManager.shared.hide() }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.secondary.opacity(0.05))
        }
        .sheet(isPresented: $showNoteEditor) {
            QuickNoteEditor(content: $noteContent)
                .modifier(GlassBackground())
        }
        .sheet(isPresented: $showPreferences) {
            PreferencesView()
                .environmentObject(state)
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .kerning(0.5)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    // MARK: - Rows

    private var panelLockRow: some View {
        ActionRow(icon: "lock.fill", iconColor: .orange, title: "锁定屏幕") { state.lockScreen() }
    }

    private var panelTrashRow: some View {
        ActionRow(icon: "trash.fill", iconColor: .red, title: "清空废纸篓") { state.emptyTrash() }
    }

    private var panelNoteRow: some View {
        ActionRow(icon: "note.text", iconColor: .blue, title: "快速笔记 → Obsidian") { showNoteEditor = true }
    }

    private var panelPomodoroRow: some View {
        ActionRow(icon: "timer", iconColor: .green, title: showPomodoro ? "收起番茄钟" : "番茄钟") {
            withAnimation(.easeInOut(duration: 0.2)) { showPomodoro.toggle() }
        }
    }

    private var panelClipboardRow: some View {
        HStack(spacing: 10) {
            Image(systemName: "doc.on.clipboard")
                .foregroundColor(.gray).font(.system(size: 12)).frame(width: 18)
            Text("剪贴板历史 (\(state.clipboardHistory.count))").font(.system(size: 12))
            Spacer()
            Button(action: { state.clearClipboard() }) {
                Image(systemName: "xmark.circle").font(.system(size: 10))
            }.buttonStyle(.plain).foregroundColor(.red.opacity(0.6)).help("清空")
            Button(action: { withAnimation(.easeInOut(duration: 0.2)) { showClipboard.toggle() } }) {
                Image(systemName: showClipboard ? "chevron.up" : "chevron.down").font(.system(size: 10))
            }.buttonStyle(.plain).foregroundColor(.secondary)
        }.padding(.horizontal, 16).padding(.vertical, 6)
    }

    private var panelInputRow: some View {
        ActionRow(icon: "textformat", iconColor: .teal, title: "输入法  (\(state.inputMethodLabel))") { state.toggleInputMethod() }
    }

    private var panelDesktopRow: some View {
        ToggleRow(icon: "desktopcomputer", iconColor: .cyan,
                  title: state.desktopIconsHidden ? "桌面图标 (隐藏)" : "桌面图标",
                  toggle: Binding(get: { state.desktopIconsHidden }, set: { _ in state.toggleDesktopIcons() }))
    }

    private var panelScreenshotRow: some View {
        HStack(spacing: 6) {
            ssBtn("区域", .region, "rectangle.dashed")
            ssBtn("窗口", .window, "macwindow")
            ssBtn("全屏", .fullscreen, "rectangle.fill")
            ssBtn("剪贴板", .clipboard, "doc.on.clipboard")
        }.padding(.horizontal, 16).padding(.vertical, 8)
    }

    private func ssBtn(_ title: String, _ mode: ScreenshotMode, _ icon: String) -> some View {
        Button(action: { state.screenshot(mode) }) {
            VStack(spacing: 3) {
                Image(systemName: icon).font(.system(size: 11))
                Text(title).font(.system(size: 9))
            }.frame(maxWidth: .infinity).padding(.vertical, 6)
                .background(Color.secondary.opacity(0.08)).cornerRadius(6)
        }.buttonStyle(.plain)
    }

    private var panelWindowRow: some View {
        HStack(spacing: 6) {
            winBtn("◧", .left, "左半"); winBtn("◨", .right, "右半")
            winBtn("⛶", .maximize, "全屏"); winBtn("⬡", .center, "居中")
        }.padding(.horizontal, 16).padding(.vertical, 8)
    }

    private func winBtn(_ icon: String, _ layout: WindowLayout, _ label: String) -> some View {
        Button(action: { state.tileWindow(layout) }) {
            VStack(spacing: 3) {
                Text(icon).font(.system(size: 16))
                Text(label).font(.system(size: 9))
            }.frame(maxWidth: .infinity).padding(.vertical, 4)
                .background(Color.secondary.opacity(0.08)).cornerRadius(6)
        }.buttonStyle(.plain)
    }

    private var panelCaffeinateRow: some View {
        ToggleRow(icon: "cup.and.saucer.fill", iconColor: .brown,
                  title: state.caffeinateManager.isActive ? "阻止休眠 (运行中)" : "阻止休眠",
                  toggle: Binding(get: { state.caffeinateManager.isActive }, set: { _ in state.toggleCaffeinate() }))
    }

    private var panelHiddenRow: some View {
        ToggleRow(icon: "eye.slash.fill", iconColor: .gray,
                  title: state.hiddenFilesShown ? "显示隐藏文件" : "隐藏文件",
                  toggle: Binding(get: { state.hiddenFilesShown }, set: { _ in state.toggleHiddenFiles() }))
    }

    private var panelMacroRow: some View {
        HStack(spacing: 6) {
            macroBtn("💼 工作", .work); macroBtn("🌙 深夜", .night)
            macroBtn("🎤 演示", .presentation); macroBtn("🚪 出门", .leaving)
        }.padding(.horizontal, 16).padding(.vertical, 8)
    }

    private func macroBtn(_ title: String, _ preset: MacroPreset) -> some View {
        Button(action: { state.activateMacro(preset) }) {
            Text(title).font(.system(size: 11, weight: .medium))
                .padding(.horizontal, 8).padding(.vertical, 5)
                .background(Color.secondary.opacity(0.08)).cornerRadius(6)
        }.buttonStyle(.plain)
    }
}
