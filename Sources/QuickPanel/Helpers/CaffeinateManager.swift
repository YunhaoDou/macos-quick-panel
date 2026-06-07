import Foundation
import AppKit
import ServiceManagement

/// Prevent Mac from sleeping (Caffeinate)
final class CaffeinateManager: ObservableObject {
    static let shared = CaffeinateManager()

    @Published var isActive = false
    private var process: Process?
    private let processLabel = "com.quickpanel.caffeinate"

    private init() {
        // Check if our caffeinate process is running
        if let output = try? shell("pgrep -fl caffeinate 2>/dev/null | grep '\(processLabel)' || echo '0'") {
            isActive = output.trimmingCharacters(in: .whitespacesAndNewlines) != "0"
        }
    }

    func toggle() {
        if isActive { stop() } else { start() }
    }

    func start() {
        guard !isActive else { return }
        process = Process()
        process?.executableURL = URL(fileURLWithPath: "/usr/bin/caffeinate")
        process?.arguments = ["-dimsu", "-w", "\(ProcessInfo.processInfo.processIdentifier)"]
        try? process?.run()
        isActive = true
    }

    func stop() {
        process?.terminate()
        process = nil
        try? shell("pgrep -fl caffeinate 2>/dev/null | grep '\(processLabel)' | awk '{print $1}' | xargs kill 2>/dev/null")
        isActive = false
    }
}
