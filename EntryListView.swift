import SwiftUI

struct EntryListView: View {
    @StateObject var viewModel: AppViewModel
    
    var body: some View {
        List(viewModel.entries) { entry in
            VStack(alignment: .leading) {
                Text(entry.project)
                Text(entry.date)
                Text(entry.duration.formatted())
            }
        }
    }
}
