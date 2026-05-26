import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel: DashboardViewModel
    
    var body: some View {
        VStack {
            Text("LocalTrack Dashboard")
                .font(.largeTitle)
            
            TimerDisplayView(viewModel: viewModel)
            
            ProjectListView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.loadProjects()
        }
    }
}

struct TimerDisplayView: View {
    @ObservedObject var viewModel: DashboardViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.formatTime())
                .font(.system(.title, .monospaced))
            HStack {
                Button(action: viewModel.startTimer) {
                    Text("Start")
                }
                Button(action: viewModel.stopTimer) {
                    Text("Stop")
                }
            }
        }
    }
}

struct ProjectListView: View {
    @ObservedObject var viewModel: DashboardViewModel
    
    var body: some View {
        List(viewModel.projects) {
            Text($0.name)
        }
    }
}
