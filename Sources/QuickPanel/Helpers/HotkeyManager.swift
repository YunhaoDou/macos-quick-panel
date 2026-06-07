import Foundation
import AppKit
import Carbon

/// Global keyboard shortcut registration
final class HotkeyManager {
    static let shared = HotkeyManager()

    private var hotKeyRef: EventHotKeyRef?
    private var hotKeyID = EventHotKeyID(signature: 0x5150, id: 1)  // 'QP' signature
    private var isRegistered = false
    private var onActivate: (() -> Void)?

    /// Register a global hotkey (⌥⌘Q by default) to show/hide the panel
    func register(combo: (keyCode: UInt32, modifiers: UInt32) = (12, UInt32(cmdKey + optionKey)),
                  onActivate: @escaping () -> Void) {
        guard !isRegistered else { return }
        self.onActivate = onActivate

        // Register the Carbon hotkey
        let status = RegisterEventHotKey(
            combo.keyCode,
            combo.modifiers,
            hotKeyID,
            GetEventDispatcherTarget(),
            0,
            &hotKeyRef
        )

        if status == noErr {
            isRegistered = true
            // Install event handler
            installEventHandler()
        }
    }

    func unregister() {
        guard isRegistered, let ref = hotKeyRef else { return }
        UnregisterEventHotKey(ref)
        isRegistered = false
    }

    private func installEventHandler() {
        // Create a custom run loop source to handle the hotkey
        // Note: This uses a Carbon event handler approach
        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard),
                                      eventKind: UInt32(kEventHotKeyPressed))

        let callback: EventHandlerUPP = { _, eventRef, userData -> OSStatus in
            guard let userData = userData else { return OSStatus(eventNotHandledErr) }
            let manager = Unmanaged<HotkeyManager>.fromOpaque(userData).takeUnretainedValue()

            var hotKeyID = EventHotKeyID()
            let err = GetEventParameter(
                eventRef,
                OSType(kEventParamDirectObject),
                OSType(typeEventHotKeyID),
                nil,
                MemoryLayout<EventHotKeyID>.size,
                nil,
                &hotKeyID
            )

            if err == noErr && hotKeyID.id == 1 {
                DispatchQueue.main.async {
                    manager.onActivate?()
                }
            }
            return noErr
        }

        let selfPtr = Unmanaged.passUnretained(self).toOpaque()
        InstallEventHandler(
            GetEventDispatcherTarget(),
            callback,
            1,
            &eventType,
            selfPtr,
            nil
        )
    }
}
