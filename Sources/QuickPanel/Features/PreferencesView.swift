import SwiftUI

struct PreferencesView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var settings = SettingsStore.shared
    @EnvironmentObject private var appState: AppState
    @State private var showFilePicker = false

    var body: some View {
        VStack(spacing: 0) {
            // ── Header ──
            HStack {
                Image(systemName: "gearshape.fill")
                    .foregroundColor(.secondary)
                Text("偏好设置")
                    .font(.headline)
                Spacer()
                Button("关闭") { dismiss() }
                    .buttonStyle(.plain)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()

            Divider()

            ScrollView {
                VStack(spacing: 24) {
                    // ── Obsidian ──
                    obsidianSection

                    Divider()

                    // ── Launch at Login ──
                    launchSection

                    Divider()

                    // ── Hotkey ──
                    hotkeySection

                    Divider()

                    // ── About ──
                    aboutSection
                }
                .padding()
            }

            Divider()

            // ── Footer ──
            HStack {
                Spacer()
                Button("完成") { dismiss() }
                    .keyboardShortcut(.defaultAction)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
            }
            .padding()
        }
        .modifier(GlassBackground())
        .frame(width: 380, height: 420)
    }

    // MARK: - Obsidian Section

    private var obsidianSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "note.text")
                    .foregroundColor(.blue)
                Text("Obsidian 笔记路径")
                    .font(.system(size: 13, weight: .medium))
            }

            Text("快速笔记将保存到此目录下的 Inbox/ 文件夹")
                .font(.caption)
                .foregroundColor(.secondary)

            HStack(spacing: 6) {
                TextField("Vault 路径", text: $settings.obsidianVaultPath)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 11))
                    .frame(height: 22)

                Button("浏览…") {
                    let panel = NSOpenPanel()
                    panel.canChooseFiles = false
                    panel.canChooseDirectories = true
                    panel.allowsMultipleSelection = false
                    panel.message = "选择 Obsidian Vault 目录"
                    panel.begin { response in
                        if response == .OK, let url = panel.url {
                            settings.obsidianVaultPath = url.path
                        }
                    }
                }
                .buttonStyle(.plain)
                .font(.caption)
                .foregroundColor(.blue)
            }

            // Quick test
            Button("测试路径") {
                let path = settings.obsidianVaultPath
                var isDir: ObjCBool = false
                if FileManager.default.fileExists(atPath: path, isDirectory: &isDir), isDir.boolValue {
                    appState.showTempFeedback("✅ Obsidian 路径有效")
                } else {
                    appState.showTempFeedback("❌ 路径不存在")
                }
            }
            .buttonStyle(.plain)
            .font(.caption)
            .foregroundColor(.secondary)
        }
    }

    // MARK: - Launch Section

    private var launchSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "power")
                    .foregroundColor(.green)
                Text("开机启动")
                    .font(.system(size: 13, weight: .medium))
            }

            Toggle(isOn: $settings.launchAtLogin) {
                Text("登录时自动启动 QuickPanel")
                    .font(.system(size: 12))
            }
            .toggleStyle(.switch)
            .controlSize(.small)
        }
    }

    // MARK: - Hotkey Section

    private var hotkeySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "keyboard")
                    .foregroundColor(.yellow)
                Text("全局快捷键")
                    .font(.system(size: 13, weight: .medium))
            }

            HStack {
                Text("当前快捷键:")
                    .font(.system(size: 12))
                Text(appState.preferredShortcut)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(4)
                Spacer()
                Text("⌥⌘Q")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text("快捷键在应用启动时注册，修改后需重启生效")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    // MARK: - About Section

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(.purple)
                Text("关于")
                    .font(.system(size: 13, weight: .medium))
            }

            HStack {
                Text("QuickPanel")
                    .font(.system(size: 12, weight: .medium))
                Spacer()
                Text("v\(settings.appVersion)")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(.secondary)
            }

            HStack {
                if appState.updater.isChecking {
                    ProgressView()
                        .scaleEffect(0.6)
                        .frame(width: 14, height: 14)
                    Text("检查更新中…")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else if appState.updater.updateAvailable {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("发现新版本 \(appState.updater.latestVersion)")
                            .font(.caption)
                            .foregroundColor(.blue)
                        Button(action: { appState.updater.downloadAndInstall() }) {
                            if appState.updater.isDownloading {
                                HStack(spacing: 4) {
                                    ProgressView()
                                        .scaleEffect(0.5)
                                    Text("\(Int(appState.updater.downloadProgress * 100))%")
                                }
                                .font(.caption)
                            } else {
                                Text("立即更新")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.blue)
                                    .cornerRadius(4)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                } else {
                    Button(action: { appState.updater.checkForUpdates() }) {
                        Text("检查更新")
                            .font(.caption)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.secondary)
                }
                Spacer()
                Text("开源 · MIT")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Text("macOS 菜单栏快捷操作面板")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
