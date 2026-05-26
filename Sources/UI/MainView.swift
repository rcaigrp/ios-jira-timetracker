import SwiftUI

struct MainView: View {
    @StateObject var timerService = TimerService()
    @State private var isShowingAddEntry = false
    @State private var newProjectName = ""
    @State private var entries: [TimeEntry] = []
    
    var body: some View {
        NavigationView {
            VStack {
                timerSection
                entryListView
                Spacer()
            }
            .navigationTitle("Time Tracker")
            .toolbar {
                ToolbarItem(placement: .leading) {
                    Button("Add") {
                        isShowingAddEntry.toggle()
                    }
                }
            }
        }
    }
    
    private var timerSection: some View {
        VStack {
            Text(formatTime(timerService.elapsedTime))
                .font(.system(size: 64, weight: .bold))
                .foregroundColor(timerService.isRunning ? .green : .gray)
            
            HStack {
                Spacer()
                Button(action: { timerService.startTimer(project: "New Project") }) {
                    Image(systemName: "play.fill")
                        .font(.largeBody)
                }
                .buttonStyle(.circle)
                .disabled(timerService.isRunning)
                
                Spacer()
                
                Button(action: timerService.stopTimer) {
                    Image(systemName: "stop.fill")
                        .font(.largeBody)
                }
                .buttonStyle(.circle)
                .disabled(!timerService.isRunning)
                
                Spacer()
            }
        }
        .padding()
    }
    
    private var entryListView: some View {
        List(entries) { entry in
            HStack {
                VStack(alignment: .leading) {
                    Text(entry.project)
                        .font(.headline)
                    Text(entry.date.formatted())
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text(formatTime(entry.duration))
            }
        }
        .sheet(isPresented: $isShowingAddEntry) {
            AddEntryView(projectName: $newProjectName, onSave: {
                timerService.startTimer(project: newProjectName)
                isShowingAddEntry = false
            })
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

struct AddEntryView: View {
    @Binding var projectName: String
    var onSave: () -> Void
    
    var body: some View {
        Form {
            TextField("Project Name", text: $projectName)
            Button("Save") {
                onSave()
            }
        }
    }
}
