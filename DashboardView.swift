import SwiftUI

struct DashboardView: View {
    @StateObject var timerVM = TimerViewModel()
    @StateObject var appVM = AppViewModel()
    
    var body: some View {
        VStack {
            TimerView(timerVM: timerVM)
            EntryListView(entries: appVM.entries)
            ManualEntryView(appVM: appVM)
        }
    }
}

struct TimerView: View {
    @ObservedObject var timerVM: TimerViewModel
    
    var body: some View {
        VStack {
            Text(formatTime(timerVM.elapsed))
                .font(.system(size: 64))
                .monospacedDigit()
            
            HStack {
                Button(action: timerVM.start) {
                    Text("Start")
                }
                Button(action: timerVM.pause) {
                    Text("Pause")
                }
                Button(action: timerVM.stop) {
                    Text("Stop")
                }
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct EntryListView: View {
    let entries: [TimeEntry]
    
    var body: some View {
        List(entries) { entry in
            Text(entry.project)
        }
    }
}

struct ManualEntryView: View {
    @ObservedObject var appVM: AppViewModel
    @State var projectName = ""
    @State var dateText = ""
    @State var notes = ""
    
    var body: some View {
        VStack {
            TextField("Project Name", text: $projectName)
            TextField("Date", text: $dateText)
            TextField("Notes", text: $notes)
            Button("Add Entry") {
                appVM.addEntry(project: projectName, date: dateText, notes: notes)
            }
        }
    }
}