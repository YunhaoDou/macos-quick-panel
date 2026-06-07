import Foundation
import AppKit

/// System-level commands: lock screen, empty trash
enum SystemCommands {
    static func lockScreen() {
        try? shell("open -a ScreenSaverEngine")
        try? shell("pmset displaysleepnow")
    }

    static func emptyTrash() {
        try? shell("rm -rfv ~/.Trash/* 2>/dev/null")
    }
}

// MARK: - Shell Helper

@discardableResult
func shell(_ command: String) throws -> String {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/bin/zsh")
    process.arguments = ["-c", command]

    let outputPipe = Pipe()
    let errorPipe = Pipe()
    process.standardOutput = outputPipe
    process.standardError = errorPipe

    try process.run()
    process.waitUntilExit()

    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

    if process.terminationStatus != 0 {
        let error = String(data: errorData, encoding: .utf8) ?? "Unknown error"
        throw ShellError.commandFailed(command: command, status: process.terminationStatus, output: error)
    }

    return String(data: outputData, encoding: .utf8) ?? ""
}

enum ShellError: LocalizedError {
    case commandFailed(command: String, status: Int32, output: String)

    var errorDescription: String? {
        switch self {
        case .commandFailed(let command, let status, let output):
            return "Command '\(command)' failed with status \(status): \(output)"
        }
    }
}
