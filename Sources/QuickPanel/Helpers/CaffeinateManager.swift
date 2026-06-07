import Foundation
import AppKit

/// Prevent Mac from sleeping (Caffeinate)
final class CaffeinateManager: ObservableObject {
    static let shared = CaffeinateManager()

    @Published var isActive = false
    private var process: Process?

    private init() {
        // Check if caffeinate is already running from a previous session
        if let output = try? shell("pgrep -x caffeinate 2>/dev/null || echo '0'") {
            isActive = output.trimmingCharacters(in: .whitespacesAndNewlines) != "0"
        }
    }

    func toggle() {
        if isActive {
            stop()
        } else {
            start()
        }
    }

    func start() {
        guard !isActive else { return }
        process = Process()
        process?.executableURL = URL(fileURLWithPath: "/usr/bin/caffeinate")
        process?.arguments = ["-dimsu"]
        try? process?.run()
        isActive = true
    }

    func stop() {
        process?.terminate()
        process = nil
        // Also kill any remaining caffeinate processes we started
        try? shell("killall caffeinate 2>/dev/null")
        isActive = false
    }
}
