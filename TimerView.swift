import SwiftUI
import Combine

struct TimerView: View {
    @State private var isRunning = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var startTime: Date?
    private var timerCancellable: AnyCancellable?
    
    var body: some View {
        VStack {
            Text(formatTime(elapsedTime))
                .font(.system(size: 48, weight: .bold))
            Button(isRunning ? "Pause" : "Start") {
                toggleTimer()
            }
            Text(isRunning ? "Tracking..." : "Stopped")
        }
        .onAppear {
            if let savedStart = UserDefaults.standard.value(forKey: "timerStart") as? Date {
                startTime = savedStart
                isRunning = true
                elapsedTime = Date().timeIntervalSince(using: savedStart)
                startTimer()
            }
        }
        .onDisappear {
            if isRunning {
                UserDefaults.standard.set(startTime, forKey: "timerStart")
            }
        }
    }
    
    private func startTimer() {
        timerCancellable?.cancel()
        timerCancellable = Timer.publishEverySecond(1).autoSubscribe().sink { _ in
            if isRunning {
                elapsedTime = Date().timeIntervalSince(using: startTime)
            }
        }
    }
    
    private func toggleTimer() {
        isRunning.toggle()
        if isRunning {
            startTime = Date()
        } else {
            UserDefaults.standard.removeObject(forKey: "timerStart")
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
