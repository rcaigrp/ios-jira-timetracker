import SwiftUI

typealias SettingsViewModel = AppViewModel

struct SettingsView: View {
    @State private var baseUrl = ""
    @State private var username = ""
    @State private var apiKey = ""
    @ObservedObject var viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        let settings = PersistenceManager.shared.loadSettings()
        self.baseUrl = settings.baseUrl ?? ""
        self.username = settings.username ?? ""
        self.apiKey = settings.apiKey ?? ""
    }
    
    var body: some View {
        Form {
            Section(header: Text("Jira Configuration")) {
                TextField("Base URL", text: $baseUrl)
                TextField("Username", text: $username)
                SecureField("API Key", text: $apiKey)
            }
            
            Section {
                Button("Save") {
                    PersistenceManager.shared.saveSettings(baseUrl: baseUrl, username: username, apiKey: apiKey)
                }
            }
        }
    }
}
