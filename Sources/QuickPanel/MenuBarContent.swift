import SwiftUI

// MARK: - 毛玻璃背景 wrapper
struct GlassBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                VisualEffectView(
                    material: .hudWindow,
                    blendingMode: .behindWindow
                )
            )
    }
}

// MARK: - AppKit NSVisualEffectView bridge
struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

// MARK: - Main Menu View

struct MenuBarContentView: View {
    @EnvironmentObject private var state: AppState
    @State private var showPomodoro = false
    @State private var showClipboard = false
    @State private var showNoteEditor = false
    @State private var noteContent = ""
    @State private var showPreferences = false

    var body: some View {
        VStack(spacing: 0) {
            // ── Search Bar ──
            searchBar

            // ── Feedback Toast ──
            if state.showFeedback {
                HStack {
                    Text(state.feedbackText)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(Color.accentColor.opacity(0.85))
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            Divider().opacity(0.3)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // 输入法与桌面
                    sectionHeader("输入 & 桌面")
                    inputMethodRow
                    desktopIconRow

                    Divider().opacity(0.3).padding(.vertical, 4)

                    // 快捷操作
                    sectionHeader("快捷操作")
                    lockRow
                    trashRow
                    noteRow
                    pomodoroRow
                    clipboardRow

                    if showPomodoro {
                        Divider().opacity(0.3).padding(.vertical, 4)
                        PomodoroView()
                    }
                    if showClipboard {
                        Divider().opacity(0.3).padding(.vertical, 4)
                        ClipboardHistoryView(items: state.clipboardHistory)
                    }

                    Divider().opacity(0.3).padding(.vertical, 4)

                    // 一键场景
                    sectionHeader("一键场景")
                    macroRow

                    Divider().opacity(0.3).padding(.vertical, 4)

                    // 截图
                    sectionHeader("截图")
                    screenshotRow

                    Divider().opacity(0.3).padding(.vertical, 4)

                    // 窗口布局
                    sectionHeader("窗口布局")
                    windowLayoutRow

                    Divider().opacity(0.3).padding(.vertical, 4)

                    // 系统工具
                    sectionHeader("系统工具")
                    caffeinateRow
                    hiddenFilesRow

                    Divider().opacity(0.3).padding(.vertical, 4)

                    // 快捷键
                    sectionHeader("快捷键")
                    shortcutRow
                }
            }
            .frame(width: 280)
            .frame(maxHeight: 520)

            // ── Footer ──
            footerRow
        }
        .modifier(GlassBackground())
        .sheet(isPresented: $showNoteEditor) {
            QuickNoteEditor(content: $noteContent)
                .modifier(GlassBackground())
        }
        .sheet(isPresented: $showPreferences) {
            PreferencesView()
                .environmentObject(state)
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
            Text("搜索文件 / App…")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            Spacer()
            Text(state.preferredShortcut)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary.opacity(0.6))
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(4)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }

    // MARK: - System Controls

    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .kerning(0.5)
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
    }

    private var lockRow: some View {
        ActionRow(icon: "lock.fill", iconColor: .orange, title: "锁定屏幕") {
            state.lockScreen()
        }
    }

    // MARK: - Input & Desktop

    private var inputMethodRow: some View {
        ActionRow(icon: "textformat", iconColor: .teal,
                  title: "输入法  (\(state.inputMethodLabel))") {
            state.toggleInputMethod()
        }
    }

    private var desktopIconRow: some View {
        ToggleRow(icon: "desktopcomputer", iconColor: .cyan,
                  title: state.desktopIconsHidden ? "桌面图标 (隐藏)" : "桌面图标",
                  toggle: Binding(
                    get: { state.desktopIconsHidden },
                    set: { _ in state.toggleDesktopIcons() }
                  ))
    }

    // MARK: - Quick Actions

    private var trashRow: some View {
        ActionRow(icon: "trash.fill", iconColor: .red, title: "清空废纸篓") {
            state.emptyTrash()
        }
    }

    private var noteRow: some View {
        ActionRow(icon: "note.text", iconColor: .blue, title: "快速笔记 → Obsidian") {
            showNoteEditor = true
        }
    }

    private var pomodoroRow: some View {
        ActionRow(icon: "timer", iconColor: .green,
                  title: showPomodoro ? "收起番茄钟" : "番茄钟") {
            withAnimation(.easeInOut(duration: 0.2)) { showPomodoro.toggle() }
        }
    }

    private var clipboardRow: some View {
        HStack(spacing: 10) {
            Image(systemName: "doc.on.clipboard")
                .foregroundColor(.gray)
                .font(.system(size: 12))
                .frame(width: 18)
            Text("剪贴板历史 (\(state.clipboardHistory.count))")
                .font(.system(size: 12))
            Spacer()
            Button(action: { state.clearClipboard() }) {
                Image(systemName: "xmark.circle")
                    .font(.system(size: 10))
            }
            .buttonStyle(.plain)
            .foregroundColor(.red.opacity(0.6))
            .help("清空剪贴板")
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) { showClipboard.toggle() }
            }) {
                Image(systemName: showClipboard ? "chevron.up" : "chevron.down")
                    .font(.system(size: 10))
            }
            .buttonStyle(.plain)
            .foregroundColor(.secondary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
    }

    // MARK: - Macros

    private var macroRow: some View {
        HStack(spacing: 6) {
            macroBtn("💼 工作", .work)
            macroBtn("🌙 深夜", .night)
            macroBtn("🎤 演示", .presentation)
            macroBtn("🚪 出门", .leaving)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
    }

    private func macroBtn(_ title: String, _ preset: MacroPreset) -> some View {
        Button(action: { state.activateMacro(preset) }) {
            Text(title)
                .font(.system(size: 11, weight: .medium))
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(Color.secondary.opacity(0.08))
                .cornerRadius(6)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Screenshot

    private var screenshotRow: some View {
        HStack(spacing: 6) {
            btn("区域", .region, "rectangle.dashed")
            btn("窗口", .window, "macwindow")
            btn("全屏", .fullscreen, "rectangle.fill")
            btn("剪贴板", .clipboard, "doc.on.clipboard")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
    }

    private func btn(_ title: String, _ mode: ScreenshotMode, _ icon: String) -> some View {
        Button(action: { state.screenshot(mode) }) {
            VStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 11))
                Text(title)
                    .font(.system(size: 9))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .background(Color.secondary.opacity(0.08))
            .cornerRadius(6)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Window Layout

    private var windowLayoutRow: some View {
        HStack(spacing: 6) {
            winBtn("◧", .left, "左半")
            winBtn("◨", .right, "右半")
            winBtn("⛶", .maximize, "全屏")
            winBtn("⬡", .center, "居中")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
    }

    private func winBtn(_ icon: String, _ layout: WindowLayout, _ label: String) -> some View {
        Button(action: { state.tileWindow(layout) }) {
            VStack(spacing: 3) {
                Text(icon)
                    .font(.system(size: 16))
                Text(label)
                    .font(.system(size: 9))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
            .background(Color.secondary.opacity(0.08))
            .cornerRadius(6)
        }
        .buttonStyle(.plain)
    }

    // MARK: - System Tools

    private var caffeinateRow: some View {
        ToggleRow(
            icon: "cup.and.saucer.fill",
            iconColor: .brown,
            title: state.caffeinateManager.isActive ? "阻止休眠 (运行中)" : "阻止休眠",
            toggle: Binding(
                get: { state.caffeinateManager.isActive },
                set: { _ in state.toggleCaffeinate() }
            )
        )
    }

    private var hiddenFilesRow: some View {
        ToggleRow(
            icon: "eye.slash.fill",
            iconColor: .gray,
            title: state.hiddenFilesShown ? "显示隐藏文件" : "隐藏文件",
            toggle: Binding(
                get: { state.hiddenFilesShown },
                set: { _ in state.toggleHiddenFiles() }
            )
        )
    }

    // MARK: - Shortcut

    private var shortcutRow: some View {
        HStack(spacing: 10) {
            Image(systemName: "keyboard")
                .foregroundColor(.yellow)
                .font(.system(size: 12))
                .frame(width: 18)
            Text("全局快捷键")
                .font(.system(size: 12))
            Spacer()
            Text(state.preferredShortcut)
                .font(.system(size: 11, weight: .medium, design: .monospaced))
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(4)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
    }

    // MARK: - Footer

    private var footerRow: some View {
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
            Button("退出") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(Color.secondary.opacity(0.05))
    }
}

// MARK: - Reusable Components

struct ToggleRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    @Binding var toggle: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .font(.system(size: 12))
                .frame(width: 18)
            Text(title)
                .font(.system(size: 12))
            Spacer()
            Toggle("", isOn: $toggle)
                .toggleStyle(.switch)
                .scaleEffect(0.8)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
    }
}

struct ActionRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.system(size: 12))
                    .frame(width: 18)
                Text(title)
                    .font(.system(size: 12))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.secondary.opacity(0.4))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
    }
}
