import Foundation

/// Obsidian vault configuration
enum ObsidianConfig {
    /// Default vault path — user should customize
    static var vaultPath: String {
        UserDefaults.standard.string(forKey: "obsidian_vault_path")
            ?? "\(NSHomeDirectory())/Library/Mobile Documents/iCloud~md~obsidian/Documents"
    }

    static var vaultName: String {
        vaultPath.split(separator: "/").last.map(String.init) ?? "Obsidian"
    }
}

/// Save notes to Obsidian vault
enum ObsidianManager {
    static func saveNote(title: String, content: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.string(from: Date())

        let inboxPath = "\(ObsidianConfig.vaultPath)/Inbox"
        try? FileManager.default.createDirectory(atPath: inboxPath, withIntermediateDirectories: true)

        let filePath = "\(inboxPath)/\(title).md"
        let noteContent = """
        ---
        date: \(dateStr)
        source: QuickPanel
        ---

        \(content)

        """
        try? noteContent.write(toFile: filePath, atomically: true, encoding: .utf8)
    }
}
