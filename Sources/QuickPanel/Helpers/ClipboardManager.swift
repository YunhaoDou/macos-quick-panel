import Foundation
import AppKit

/// NSPasteboard-based clipboard history
final class ClipboardManager {
    static let shared = ClipboardManager()
    private(set) var recentItems: [String] = []
    private let maxItems = 20
    private var lastChangeCount = 0

    private init() {}

    /// Poll for clipboard changes (called periodically)
    func poll() {
        let pasteboard = NSPasteboard.general
        guard pasteboard.changeCount != lastChangeCount else { return }
        lastChangeCount = pasteboard.changeCount

        guard let items = pasteboard.pasteboardItems else { return }
        for item in items {
            if let str = item.string(forType: .string) {
                addItem(str)
            }
        }
    }

    func clear() {
        recentItems.removeAll()
        lastChangeCount = 0
    }

    private func addItem(_ text: String) {
        // Avoid duplicates at the top
        recentItems.removeAll { $0 == text }
        recentItems.insert(text, at: 0)
        if recentItems.count > maxItems {
            recentItems = Array(recentItems.prefix(maxItems))
        }
    }
}
