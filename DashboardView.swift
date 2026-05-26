import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel: TimerViewModel
    
    var body: some View {
        VStack {
            Text("LocalTrack")
                .font(.largeTitle)
                .padding()
            
            TimerView(viewModel: viewModel)
            
            EntryListView()
        }
        .padding()
    }
}

struct TimerView: View {
    @ObservedObject var viewModel: TimerViewModel
    
    var body: some View {
        VStack {
            Text(formatTime(viewModel.elapsedSeconds))
                .font(.system(size: 64, weight: .bold))
                .padding()
            
            HStack {
                if viewModel.isRunning {
                    Button(action: viewModel.pauseTimer) {
                        Text("Pause")
                            .padding()
                    }
                } else {
                    Button(action: viewModel.startTimer) {
                        Text("Start")
                            .padding()
                    }
                }
                
                Button(action: viewModel.stopTimer) {
                    Text("Stop")
                        .padding()
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let seconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct EntryListView: View {
    var body: some View {
        List {
            ForEach(0..<5) { _ in
                Text("Entry")
            }
        }
    }
}
