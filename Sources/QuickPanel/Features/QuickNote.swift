import SwiftUI

/// Quick Note editor sheet — saves to Obsidian vault
struct QuickNoteEditor: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var content: String

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("快速笔记")
                    .font(.headline)
                Spacer()
                Button("保存并关闭") {
                    saveNote()
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
            }

            TextEditor(text: $content)
                .font(.body)
                .frame(minWidth: 300, minHeight: 200)
                .border(Color(.gridColor), width: 0.5)

            HStack {
                Button("取消") { dismiss() }
                    .buttonStyle(.plain)
                Spacer()
                Text("保存到 \(ObsidianConfig.vaultName)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(width: 420, height: 320)
    }

    private func saveNote() {
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let title = "快捷笔记 \(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short))"
        let filename = title.replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: ":", with: ".")
        ObsidianManager.saveNote(title: filename, content: content)
        content = ""
    }
}
