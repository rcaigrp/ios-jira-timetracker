import SwiftUI

struct SettingsView: View {
    @State var baseUrl = ""
    @State var username = ""
    @State var apiKey = ""
    
    var body: some View {
        Form {
            Section(header: Text("Jira Credentials")) {
                TextField("Base URL", text: $baseUrl)
                TextField("Username", text: $username)
                SecureField("API Key", text: $apiKey)
            }
            Button("Save") {
                saveCredentials()
            }
        }
    }
    
    private func saveCredentials() {
        // Mock secure storage
    }
}
