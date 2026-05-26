import SwiftUI
import Foundation

@main
struct AppEntry: App {
    var body: some Scene {
        WindowGroup {
            DashboardView()
        }
    }
}

struct DashboardView: View {
    @State private var timerRunning = false
    @State private var elapsedTime = 0.0
    @State private var projects: [Project] = []
    
    var body: some View {
        VStack {
            Text("Dashboard")
            TimerDisplay(elapsedTime: elapsedTime)
            ProjectListView(projects: projects)
        }
        .onAppear {
            loadProjects()
            handleApplicationDidResume()
        }
        .onDisappear {
            handleApplicationWillResignActive()
        }
    }
    
    private func loadProjects() {
        if let data = UserDefaults.standard.data(forKey: "projects") {
            let decoder = JSONDecoder()
            if let loaded = try? decoder.decode([Project].self, from: data) {
                projects = loaded
            }
        }
    }
    
    private func handleApplicationWillResignActive() {
        timerRunning = false
    }
    
    private func handleApplicationDidResume() {
        timerRunning = true
    }
}

struct TimerDisplay: View {
    let elapsedTime: Double
    var body: some View {
        Text("\(elapsedTime)s")
    }
}

struct ProjectListView: View {
    let projects: [Project]
    var body: some View {
        List(projects) { project in
            Text(project.name)
        }
    }
}

struct Project: Identifiable {
    let id = UUID()
    let name: String
}