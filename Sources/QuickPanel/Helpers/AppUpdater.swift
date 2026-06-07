import Foundation
import AppKit

/// In-app updater that checks GitHub Releases for the latest version
final class AppUpdater: ObservableObject {
    static let shared = AppUpdater()

    private let repo = "YunhaoDou/macos-quick-panel"
    private let currentVersion = "1.1.0"
    private let appName = "QuickPanel"

    @Published var isChecking = false
    @Published var updateAvailable = false
    @Published var latestVersion = ""
    @Published var downloadURL: URL?
    @Published var releaseNotes = ""
    @Published var isDownloading = false
    @Published var downloadProgress: Double = 0
    @Published var statusMessage = ""

    private init() {}

    /// Check for updates via GitHub Releases API
    func checkForUpdates() {
        guard !isChecking else { return }
        isChecking = true
        statusMessage = "检查更新中…"

        let urlString = "https://api.github.com/repos/\(repo)/releases/latest"
        guard let url = URL(string: urlString) else {
            statusMessage = "检查失败"
            isChecking = false
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async {
                guard let self = self else { return }

                if let error = error {
                    self.statusMessage = "网络错误: \(error.localizedDescription)"
                    self.isChecking = false
                    return
                }

                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    self.statusMessage = "解析失败"
                    self.isChecking = false
                    return
                }

                let tag = json["tag_name"] as? String ?? ""
                let body = json["body"] as? String ?? ""
                let assets = json["assets"] as? [[String: Any]] ?? []

                // Find DMG asset
                var dmgURL: URL?
                for asset in assets {
                    if let name = asset["name"] as? String,
                       name.hasSuffix(".dmg"),
                       let urlStr = asset["browser_download_url"] as? String {
                        dmgURL = URL(string: urlStr)
                        break
                    }
                }

                self.latestVersion = tag
                self.downloadURL = dmgURL
                self.releaseNotes = body

                // Compare versions
                let current = self.currentVersion
                let latest = tag.replacingOccurrences(of: "v", with: "")
                    .replacingOccurrences(of: "V", with: "")

                if latest.compare(current, options: .numeric) == .orderedDescending {
                    self.updateAvailable = true
                    self.statusMessage = "发现新版本 \(tag)"
                } else {
                    self.updateAvailable = false
                    self.statusMessage = "已是最新版本 (\(self.currentVersion))"
                }

                self.isChecking = false
            }
        }.resume()
    }

    /// Download and install the update
    func downloadAndInstall() {
        guard let url = downloadURL else {
            statusMessage = "下载链接无效"
            return
        }

        isDownloading = true
        downloadProgress = 0
        statusMessage = "下载更新中…"

        let task = URLSession.shared.downloadTask(with: url) { [weak self] tempURL, _, error in
            DispatchQueue.main.async {
                guard let self = self else { return }

                if let error = error {
                    self.statusMessage = "下载失败: \(error.localizedDescription)"
                    self.isDownloading = false
                    return
                }

                guard let tempURL = tempURL else {
                    self.statusMessage = "下载失败: 无文件"
                    self.isDownloading = false
                    return
                }

                self.statusMessage = "下载完成，准备安装…"

                // Move to a permanent temp location
                let dmgPath = "/tmp/\(self.appName)-update.dmg"
                try? FileManager.default.removeItem(atPath: dmgPath)
                try? FileManager.default.moveItem(at: tempURL, to: URL(fileURLWithPath: dmgPath))

                // Install
                self.installUpdate(dmgPath: dmgPath)
            }
        }

        // Track progress
        let observation = task.progress.observe(\.fractionCompleted) { [weak self] progress, _ in
            DispatchQueue.main.async {
                self?.downloadProgress = progress.fractionCompleted
            }
        }

        task.resume()

        // Store observation to prevent deallocation
        objc_setAssociatedObject(task, "progressObservation", observation, .OBJC_ASSOCIATION_RETAIN)
    }

    private func installUpdate(dmgPath: String) {
        statusMessage = "安装更新…"

        let appPath = "/Applications/\(appName).app"
        let backupPath = "/tmp/\(appName)-backup.app"

        // 1. Mount DMG
        let mountTask = Process()
        mountTask.executableURL = URL(fileURLWithPath: "/usr/bin/hdiutil")
        mountTask.arguments = ["attach", dmgPath, "-nobrowse", "-mountpoint", "/tmp/\(appName)-mount"]

        do {
            try mountTask.run()
            mountTask.waitUntilExit()
        } catch {
            statusMessage = "挂载 DMG 失败"
            isDownloading = false
            return
        }

        // 2. Backup old app
        if FileManager.default.fileExists(atPath: appPath) {
            try? FileManager.default.removeItem(atPath: backupPath)
            try? FileManager.default.moveItem(atPath: appPath, toPath: backupPath)
        }

        // 3. Copy new app
        let mountedAppPath = "/tmp/\(appName)-mount/\(appName).app"
        do {
            try FileManager.default.copyItem(atPath: mountedAppPath, toPath: appPath)
        } catch {
            // Restore backup
            try? FileManager.default.moveItem(atPath: backupPath, toPath: appPath)
            statusMessage = "安装失败: \(error.localizedDescription)"
            isDownloading = false
            // Unmount DMG
            try? shell("hdiutil detach /tmp/\(appName)-mount -quiet")
            return
        }

        // 4. Unmount DMG
        try? shell("hdiutil detach /tmp/\(appName)-mount -quiet")

        // 5. Clean up
        try? FileManager.default.removeItem(atPath: dmgPath)

        statusMessage = "更新完成！重启应用中…"

        // 6. Relaunch
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/open")
            process.arguments = [appPath]
            try? process.run()

            // Kill old instance
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}
