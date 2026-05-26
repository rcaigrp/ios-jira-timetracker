import SwiftUI

struct DashboardView: View {
    @StateObject var timerManager = TimerManager()
    @StateObject var projectStore = ProjectStore()
    @State private var projectTitle: String = ""
    @State private var projectNotes: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Active Timer")) {
                    HStack {
                        Text(timerManager.elapsedSeconds.formattedDuration)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                        Button(timerManager.isRunning ? "Pause" : "Start") {
                            if timerManager.isRunning {
                                timerManager.pauseTimer()
                            } else {
                                timerManager.startTimer()
                            }
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(timerManager.isRunning ? .orange : .green)
                    }
                    .onAppear {
                        if UserDefaults.standard.object(forKey: "timer_start_time") != nil {
                            timerManager.resumeTimer()
                        }
                    }
                }
                
                Section(header: Text("Recent Entries")) {
                    ForEach(projectStore.projects) { project in
                        VStack(alignment: .leading) {
                            Text(project.name)
                            Text(project.formattedDuration)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("LocalTrack")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save Entry") {
                        if let start = timerManager.startTime, timerManager.isRunning == false {
                            let newProject = Project(name: projectTitle, startTime: start, endTime: Date(), duration: timerManager.elapsedSeconds, notes: projectNotes)
                            projectStore.addProject(newProject)
                            timerManager.stopTimer()
                            projectTitle = ""
                            projectNotes = ""
                        }
                    }
                    .disabled(timerManager.elapsedSeconds == 0)
                }
            }
        }
    }
}