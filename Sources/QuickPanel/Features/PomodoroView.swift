import SwiftUI

struct PomodoroView: View {
    @ObservedObject var timer: PomodoroTimer

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: timer.state.isBreak ? "cup.and.saucer.fill" : "timer")
                    .foregroundColor(timer.state.isBreak ? .orange : .green)
                Text(timer.state.isBreak ? "休息中" : "专注中")
                    .font(.caption)
                Spacer()
                Text(timer.formattedTime)
                    .font(.system(.title3, design: .monospaced))
                    .foregroundColor(timer.state.isRunning ? .primary : .secondary)
                Spacer()
                HStack(spacing: 4) {
                    if timer.state.isRunning {
                        Button(action: { timer.stop() }) {
                            Image(systemName: "pause.fill").font(.caption)
                        }.buttonStyle(.plain)
                    } else {
                        Button(action: { timer.start { NSSound.beep() } }) {
                            Image(systemName: "play.fill").font(.caption)
                        }.buttonStyle(.plain)
                    }
                    Button(action: { timer.reset() }) {
                        Image(systemName: "arrow.counterclockwise").font(.caption)
                    }.buttonStyle(.plain).foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 4)

            if timer.state.cycles > 0 {
                HStack {
                    Spacer()
                    Text("已完成 \(timer.state.cycles) 个番茄")
                        .font(.caption2).foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 4)
            }
        }
    }
}
