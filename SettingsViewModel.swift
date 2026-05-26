import Foundation

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var baseUrl = ""
    @Published var username = ""
    @Published var apiKey = ""
    
    func save() {
        // Mock secure storage
    }
}
