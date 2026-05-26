import SwiftUI

struct DashboardView: View {
    @State private var entries: [TimeIntervalEntry] = []
    @State private var showSettings = false
    
    var body: some View {
        List(entries) { entry in
            VStack(alignment: .leading) {
                Text(entry.project)
                Text(entry.date)
                Text("Duration: \(formatDuration(entry.duration))")
                if let notes = entry.notes {
                    Text(notes)
                }
            }
        }
        .onAppear {
            entries = Persistence.shared.loadEntries()
        }
        .toolbar {
            Button("Settings") { showSettings = true }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
