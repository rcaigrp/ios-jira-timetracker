import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel: DashboardViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Timer")) {
                    Text(viewModel.displayTime)
                    if viewModel.isRunning {
                        Button("Stop") {
                            viewModel.stopTimer()
                        }
                    } else {
                        Button("Start") {
                            viewModel.startTimer()
                        }
                    }
                }
                Section(header: Text("Manual Entry")) {
                    TextField("Project Name", text: $viewModel.projectName)
                    Button("Add Manual Entry") {
                        viewModel.addManualEntry()
                    }
                }
                Section(header: Text("Projects")) {
                    ForEach(viewModel.projects, id: \.id) { project in
                        Text(project.name)
                    }
                }
            }
            .navigationTitle("LocalTrack")
            .toolbar {
                ToolbarItem {
                    NavigationLink("Settings") {
                        SettingsView()
                    }
                }
            }
        }
    }
}
