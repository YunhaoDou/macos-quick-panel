import Foundation
import Combine

/// Pomodoro timer state
struct PomodoroState {
    var isRunning = false
    var remaining = 1500        // 25 min in seconds
    var workDuration = 1500     // 25 min
    var breakDuration = 300     // 5 min
    var isBreak = false
    var cycles = 0
}

/// Pomodoro timer logic
final class PomodoroTimer: ObservableObject {
    @Published var state = PomodoroState()
    private var timer: AnyCancellable?
    private var onComplete: (() -> Void)?

    func start(onComplete: (() -> Void)? = nil) {
        self.onComplete = onComplete
        state.isRunning = true
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    func stop() {
        timer?.cancel()
        timer = nil
        state.isRunning = false
    }

    func reset() {
        stop()
        state.remaining = state.workDuration
        state.isBreak = false
    }

    private func tick() {
        if state.remaining > 0 {
            state.remaining -= 1
        } else {
            // Cycle complete
            if state.isBreak {
                state.cycles += 1
                state.isBreak = false
                state.remaining = state.workDuration
            } else {
                state.isBreak = true
                state.remaining = state.breakDuration
            }
            onComplete?()
        }
    }

    var formattedTime: String {
        let mins = state.remaining / 60
        let secs = state.remaining % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}
