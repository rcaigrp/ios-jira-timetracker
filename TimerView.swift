import SwiftUI

struct TimerView: View {
    @Binding var isRunning: Bool
    @Binding var timerText: String
    
    var body: some View {
        VStack {
            Text(timerText)
                .font(.system(size: 48))
            
            Button(isRunning ? "Pause" : "Start") {
                isRunning.toggle()
            }
        }
    }
}
