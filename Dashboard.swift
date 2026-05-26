import SwiftUI

struct DashboardView: View {
    @State private var isTimerRunning = false
    @State private var timerText = "00:00:00"
    @State private var entries = [Entry(project: "Project A", date: "2023-01-01", duration: 1.5)]
    
    var body: some View {
        VStack {
            Text("LocalTrack")
                .font(.largeTitle)
            
            TimerView(isRunning: $isTimerRunning, timerText: $timerText)
            
            List(entries, id: \.project) { entry in
                Text("\(entry.project) - \(entry.duration)h")
            }
            
            NavigationLink(destination: SettingsView()) {
                Text("Settings")
            }
        }
    }
}

struct Entry: Hashable {
    let project: String
    let date: String
    let duration: Double
}
