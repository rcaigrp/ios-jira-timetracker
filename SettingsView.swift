import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("jiraBaseUrl") private var baseUrl = ""
    @AppStorage("jiraUsername") private var username = ""
    @AppStorage("jiraApiKey") private var apiKey = ""
    
    var body: some View {
        Form {
            Section(header: Text("Jira Configuration")) {
                TextField("Base URL", text: $baseUrl)
                TextField("Username", text: $username)
                SecureField("API Key", text: $apiKey)
            }
            
            Section {
                Button("Save & Test Connection") {
                    JiraService.shared.configure(baseUrl: baseUrl, username: username, apiKey: apiKey)
                }
            }
            
            Section {
                Button("Back") { dismiss() }
            }
        }
    }
}
