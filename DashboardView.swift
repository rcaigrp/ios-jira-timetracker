import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel: TimerViewModel
    
    var body: some View {
        VStack {
            Text("Elapsed: \(viewModel.elapsedTime.formatted())")
            Button("Start") { viewModel.startTimer() }
            Button("Stop") { viewModel.stopTimer() }
        }
    }
}
