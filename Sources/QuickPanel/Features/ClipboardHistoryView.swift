import SwiftUI

struct ClipboardHistoryView: View {
    let items: [String]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "doc.on.clipboard")
                    .foregroundColor(.gray)
                Text("剪贴板历史")
                    .font(.caption)
                Spacer()
                if items.isEmpty {
                    Text("暂无记录")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 4)

            if !items.isEmpty {
                ForEach(Array(items.prefix(10).enumerated()), id: \.offset) { _, item in
                    Button(action: {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(item, forType: .string)
                    }) {
                        HStack {
                            Text(item.prefix(60) + (item.count > 60 ? "…" : ""))
                                .font(.system(size: 11))
                                .lineLimit(1)
                            Spacer()
                            Image(systemName: "doc.on.doc")
                                .font(.caption2)
                                .foregroundColor(.secondary.opacity(0.5))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 3)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
