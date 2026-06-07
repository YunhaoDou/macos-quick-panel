import SwiftUI

struct MenuBarContentView: View {
    @EnvironmentObject private var state: AppState
    @State private var searchText = ""
    @State private var showPomodoro = false
    @State private var showClipboard = false
    @State private var showNoteEditor = false
    @State private var noteContent = ""

    var body: some View {
        VStack(spacing: 0) {
            // ── Search bar ──
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("搜索文件 / App…", text: $searchText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 13))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.textBackgroundColor).opacity(0.3))

            Divider()

            ScrollView {
                VStack(spacing: 0) {
                    // ── System Controls ──
                    systemSection

                    Divider().padding(.vertical, 4)

                    // ── Quick Actions ──
                    quickActionsSection

                    if showPomodoro {
                        Divider().padding(.vertical, 4)
                        pomodoroSection
                    }

                    if showClipboard {
                        Divider().padding(.vertical, 4)
                        clipboardSection
                    }

                    Divider().padding(.vertical, 4)

                    // ── One-Click Macros ──
                    macroSection

                    Divider().padding(.vertical, 4)

                    // ── Footer ──
                    footerSection
                }
            }
            .frame(width: 280)
            .frame(maxHeight: 520)
        }
        .sheet(isPresented: $showNoteEditor) {
            QuickNoteEditor(content: $noteContent)
        }
    }

    // MARK: - System Section

    private var systemSection: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "系统控制")

            // Dark Mode
            ToggleRow(
                icon: "moon.fill",
                iconColor: .purple,
                title: "深色模式",
                toggle: $state.isDarkMode
            )

            // Audio Output
            AudioDeviceRow(
                devices: state.audioDevices,
                selected: $state.selectedAudioDevice,
                onRefresh: { state.refreshAudioDevices() },
                onSelect: { state.switchAudio(to: $0) }
            )

            // Do Not Disturb
            ToggleRow(
                icon: "moon.zzz.fill",
                iconColor: .indigo,
                title: "勿扰模式",
                toggle: Binding(
                    get: { state.isDNDEnabled },
                    set: { _ in state.toggleDND() }
                )
            )

            // Lock Screen
            ActionRow(
                icon: "lock.fill",
                iconColor: .orange,
                title: "锁定屏幕"
            ) { state.lockScreen() }
        }
    }

    // MARK: - Quick Actions

    private var quickActionsSection: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "快捷操作")

            ActionRow(
                icon: "trash.fill",
                iconColor: .red,
                title: "清空废纸篓"
            ) { state.emptyTrash() }

            ActionRow(
                icon: "note.text",
                iconColor: .blue,
                title: "快速笔记 → Obsidian"
            ) { showNoteEditor = true }

            ActionRow(
                icon: "timer",
                iconColor: .green,
                title: "番茄钟"
            ) { showPomodoro.toggle() }

            ActionRow(
                icon: "doc.on.clipboard",
                iconColor: .gray,
                title: "剪贴板历史 (\(state.clipboardHistory.count))"
            ) { showClipboard.toggle() }
        }
    }

    // MARK: - Pomodoro

    private var pomodoroSection: some View {
        PomodoroView()
    }

    // MARK: - Clipboard

    private var clipboardSection: some View {
        ClipboardHistoryView(items: state.clipboardHistory)
    }

    // MARK: - Macros

    private var macroSection: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "一键场景")

            HStack(spacing: 8) {
                MacroButton(title: "💼 工作", preset: .work)
                MacroButton(title: "🌙 深夜", preset: .night)
                MacroButton(title: "🎤 演示", preset: .presentation)
                MacroButton(title: "🚪 出门", preset: .leaving)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
    }

    // MARK: - Footer

    private var footerSection: some View {
        HStack {
            Button("偏好设置") {
                // Future: settings window
            }
            .buttonStyle(.plain)
            .font(.caption)
            .foregroundColor(.secondary)

            Spacer()

            Button("退出") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
}

// MARK: - Sub-views

struct SectionHeader: View {
    let title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
}

struct ToggleRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    @Binding var toggle: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 20)
            Text(title)
                .font(.system(size: 13))
            Spacer()
            Toggle("", isOn: $toggle)
                .toggleStyle(.switch)
                .scaleEffect(0.8)
        }
        .padding(.horizontal, 12)
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
                    .frame(width: 20)
                Text(title)
                    .font(.system(size: 13))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundColor(.secondary.opacity(0.5))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
}

struct MacroButton: View {
    @EnvironmentObject private var state: AppState
    let title: String
    let preset: MacroPreset

    var body: some View {
        Button(action: { state.activateMacro(preset) }) {
            Text(title)
                .font(.system(size: 12))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color(.controlBackgroundColor))
                .cornerRadius(6)
        }
        .buttonStyle(.plain)
    }
}

struct AudioDeviceRow: View {
    let devices: [AudioDevice]
    @Binding var selected: String
    let onRefresh: () -> Void
    let onSelect: (String) -> Void

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "speaker.wave.2.fill")
                .foregroundColor(.blue)
                .frame(width: 20)
            Text("输出设备")
                .font(.system(size: 13))
            Spacer()
            if devices.isEmpty {
                Text("未检测到")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                Picker("", selection: $selected) {
                    ForEach(devices, id: \.name) { device in
                        Text(device.name).tag(device.name)
                    }
                }
                .pickerStyle(.menu)
                .scaleEffect(0.9)
                .onChange(of: selected) { newValue in
                    onSelect(newValue)
                }
            }
            Button(action: onRefresh) {
                Image(systemName: "arrow.clockwise")
                    .font(.caption)
            }
            .buttonStyle(.plain)
            .foregroundColor(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
}
