import Foundation
import Carbon

/// Input method switching via TIS (Text Input Sources) API
enum InputMethodManager {
    /// Helper to read a CFString property from a TIS input source
    private static func propertyString(_ source: TISInputSource, _ key: CFString) -> String? {
        guard let ptr = TISGetInputSourceProperty(source, key) else { return nil }
        let cfStr = Unmanaged<CFString>.fromOpaque(ptr).takeUnretainedValue()
        return cfStr as String
    }

    /// Get all available input sources
    static func listSources() -> [(id: String, name: String)] {
        guard let sourceListRaw = TISCreateInputSourceList(nil, false),
              sourceListRaw.takeRetainedValue() is [TISInputSource] else { return [] }
        let sourceList = sourceListRaw.takeRetainedValue() as! [TISInputSource]
        return sourceList.compactMap { source -> (id: String, name: String)? in
            guard
                let type = TISGetInputSourceProperty(source, kTISPropertyInputSourceType),
                Unmanaged<CFString>.fromOpaque(type).takeUnretainedValue() as String == kTISTypeKeyboardInputMode as String,
                let id = propertyString(source, kTISPropertyInputSourceID),
                let name = propertyString(source, kTISPropertyLocalizedName)
            else { return nil }
            return (id, name)
        }
    }

    /// Get current input source
    static func currentSource() -> String {
        guard let source = TISCopyCurrentKeyboardInputSource()?.takeRetainedValue() else { return "" }
        return propertyString(source, kTISPropertyInputSourceID) ?? ""
    }

    /// Get current input source name
    static func currentSourceName() -> String {
        guard let source = TISCopyCurrentKeyboardInputSource()?.takeRetainedValue() else { return "ABC" }
        return propertyString(source, kTISPropertyLocalizedName) ?? "ABC"
    }

    /// Short display name (e.g. "中" for Sogou, "英" for ABC)
    static func currentShortName() -> String {
        let name = currentSourceName()
        if name.contains("搜狗") || name.contains("Sogou") || name.contains("拼音") {
            return "中"
        }
        if name == "ABC" || name == "U.S." || name == "English" {
            return "英"
        }
        return String(name.prefix(2))
    }

    /// Switch to a specific input source by its ID
    static func switchTo(id: String) {
        guard let sourceListRaw = TISCreateInputSourceList(
            [kTISPropertyInputSourceID: id] as CFDictionary,
            false
        ) else { return }
        let sourceList = sourceListRaw.takeRetainedValue() as! [TISInputSource]
        guard let target = sourceList.first else { return }
        TISSelectInputSource(target)
    }

    /// Toggle between Sogou Pinyin and the previous input source
    static func toggleChineseEnglish() {
        let current = currentSource()

        // Try to find Sogou input source
        let allSources = listSources()
        let sogouSources = allSources.filter { $0.name.contains("搜狗") || $0.id.contains("Sogou") }

        if current.contains("Sogou") || current.contains("SCIM") || current.contains("搜狗") {
            // Currently on Chinese, switch to ABC
            if let abc = allSources.first(where: { $0.id.hasSuffix("ABC") || $0.name == "ABC" }) {
                switchTo(id: abc.id)
            }
        } else {
            // Currently on English, switch to Sogou
            if let sogou = sogouSources.first {
                switchTo(id: sogou.id)
            } else {
                // Fallback to SCIM (Apple Chinese input)
                let scim = allSources.filter { $0.id.contains("SCIM") }
                if let firstSCIM = scim.first(where: { $0.id.contains("ITABC") }) {
                    switchTo(id: firstSCIM.id)
                } else if let anyChinese = allSources.first(where: { $0.id.contains("Pinyin") }) {
                    switchTo(id: anyChinese.id)
                }
            }
        }
    }
}
