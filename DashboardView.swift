import SwiftUI

struct DashboardView: View {
    @State private var timerManager = TimerManager.shared
    @State private var projectService = ProjectService.shared
    @State private var entries: [ProjectEntry] = []
    @State private var showingAddEntry = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Timer Display
                TimerDisplayView(timerManager: timerManager)
                
                Spacer()
                
                // Controls
                HStack {
                    Button(action: { timerManager.toggle() }) {
                        Text(timerManager.isRunningState() ? "Pause" : "Resume")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Button(action: { timerManager.stop() }) {
                        Text("Stop")
                            .font(.headline)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Spacer()
                
                // Summary
                Text("Today's Summary: \(timerManager.getFormattedTime())")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                // Recent Entries
                Text("Recent Entries")
                    .font(.title2)
                    .padding(.top)
                
                List(entries) { entry in
                    EntryRowView(entry: entry)
                }
                
                Button("Add Manual Entry") {
                    showingAddEntry = true
                }
                .padding()
            }
            .onAppear {
                entries = projectService.getEntries()
            }
            .navigationTitle("LocalTrack")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear") {
                        projectService.clearEntries()
                        entries = []
                    }
                }
            }
        }
    }
}

struct TimerDisplayView: View {
    @ObservedObject var timerManager: TimerManager
    
    var body: some View {
        VStack {
            Text(timerManager.getFormattedTime())
                .font(.system(size: 64, weight: .bold))
                .foregroundColor(.primary)
            Text(timerManager.isRunningState() ? "Running" : "Paused")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
}

struct EntryRowView: View {
    var entry: ProjectEntry
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.project)
                .font(.headline)
            Text(entry.date)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(entry.notes)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical)
    }
}
