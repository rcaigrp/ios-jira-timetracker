import SwiftUI

struct DashboardView: View {
    @StateObject var timerService = TimerService()
    @StateObject var jiraService = JiraService()
    @State var projectList: [String] = []
    
    var body: some View {
        ScrollView {
            VStack {
                TimerView(timerService: timerService)
                
                Divider()
                
                HStack {
                    Text("Projects")
                    Spacer()
                    Button("Sync") {
                        jiraService.fetchProjects { projects in
                            projectList = projects
                        }
                    }
                }
                
                List(projectList, id: \.self) { project in
                    Text(project)
                }
            }
        }
        .onAppear {
            if let creds = KeychainHelper.loadCredential() {
                // Auto sync if configured
                jiraService.fetchProjects { projects in
                    projectList = projects
                }
            }
        }
    }
}

struct TimerView: View {
    @ObservedObject var timerService: TimerService
    
    var body: some View {
        HStack {
            Text(formatTime(timerService.elapsed))
                .font(.largeTitle)
            Spacer()
            if timerService.isRunning {
                Button("Pause") { timerService.pause() }
            } else {
                Button("Start") { timerService.start() }
            }
            Button("Stop") { timerService.stop() }
        }
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%d:%02d", minutes, secs)
    }
}
