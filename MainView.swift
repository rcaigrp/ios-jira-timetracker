import SwiftUI

struct MainView: View {
    @StateObject var timerService = TimerService()
    @State private var projects: [JiraProject] = []
    @State private var isSettingsPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                TimerView(service: timerService)
                
                Divider()
                
                Text("Projects")
                    .font(.title)
                
                List(projects) { project in
                    Text(project.name)
                }
                
                Button("Refresh Projects") {
                    loadProjects()
                }
            }
            .navigationTitle("LocalTrack")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Settings") {
                        isSettingsPresented = true
                    }
                }
            }
            .sheet(isPresented: $isSettingsPresented) {
                SettingsView { url, user, token in
                    KeychainHelper.save(url: url, username: user, token: token)
                }
            }
        }
    }
    
    private func loadProjects() {
        let (url, user, token) = KeychainHelper.loadJiraCredentials()
        if !url.isEmpty {
            // In a real app, we'd call async JiraService
        }
    }
}

struct TimerView: View {
    @ObservedObject var service: TimerService
    
    var body: some View {
        VStack {
            Text("\(service.totalElapsed.formattedTime())")
                .font(.largeTitle)
            
            HStack {
                Spacer()
                Button(service.isRunning ? "Pause" : "Start") {
                    if service.isRunning {
                        service.pause()
                    } else {
                        service.start()
                    }
                }
                Spacer()
                Button("Stop") {
                    service.stop()
                }
            }
        }
        .padding()
    }
}

extension TimeInterval {
    func formattedTime() -> String {
        let hours = Int(self) / 3600
        let minutes = (Int(self) % 3600) / 60
        let seconds = Int(self) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
