import SwiftUI

@main
struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            DashboardView(viewModel: TimerViewModel())
        }
    }
}
