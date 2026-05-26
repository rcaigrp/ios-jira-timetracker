import SwiftUI
import Foundation

struct DashboardView: View {
    @State private var isRunning = false
    @State private var startTime: Date?
    @State private var timerInterval: TimeInterval = 0
    
    init() {
        if let savedStart = UserDefaults.standard.string(forKey: "startTime") {
            // Parse and set startTime
        }
        if let savedInterval = UserDefaults.standard.double(forKey: "timerInterval") {
            timerInterval = savedInterval
        }
    }
    
    var body: some View {
        VStack {
            Text("Time Tracker")
                .font(.largeTitle)
            
            TimerDisplayView(duration: timerInterval)
            
            Button(action: toggleTimer) {
                Text(isRunning ? "Stop" : "Start")
            }
            
            ProjectList()
        }
        .onAppear {
            NotificationCenter.default.addObserver(
                forName: UIApplication.didEnterBackgroundNotification,
                object: nil,
                queue: .main
            ) { _ in
                self.isRunning = false
            }
        }
        .onDisappear {
            UserDefaults.standard.set(isRunning ? Date() : nil, forKey: "startTime")
            UserDefaults.standard.set(timerInterval, forKey: "timerInterval")
        }
    }
    
    func toggleTimer() {
        if isRunning {
            isRunning = false
        } else {
            startTime = Date()
            isRunning = true
        }
    }
}

struct TimerDisplayView: View {
    let duration: TimeInterval
    var body: some View {
        Text("\(Int(duration / 60)) min")
    }
}

struct ProjectList: View {
    var body: some View {
        List {
            Text("Project 1")
        }
    }
}

@main
struct TimeTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            DashboardView()
        }
    }
}
