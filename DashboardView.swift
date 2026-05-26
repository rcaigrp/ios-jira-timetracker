import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel: DashboardViewModel
    
    var body: some View {
        VStack {
            TimerDisplay(elapsedTime: viewModel.elapsedTime, isRunning: viewModel.timerRunning)
            
            TextField("Project Name", text: $viewModel.currentProjectName)
                .textFieldStyle(.plain)
                .padding()
            
            HStack {
                if viewModel.timerRunning {
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
            
            List(viewModel.projects) { project in
                HStack {
                    Text(project.name)
                    Spacer()
                    Text("\(formatTime(project.duration))")
                }
            }
        }
        .padding()
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct TimerDisplay: View {
    let elapsedTime: TimeInterval
    let isRunning: Bool
    
    var body: some View {
        Text("\(formatTime(elapsedTime))")
            .font(.system(size: 48))
            .fontWeight(.bold)
            .padding()
        
        Text(isRunning ? "Running" : "Stopped")
            .foregroundColor(isRunning ? .green : .gray)
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}