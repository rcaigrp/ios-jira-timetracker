import Foundation
import UIKit

class BackgroundHandler {
    static let shared = BackgroundHandler()
    private var timerViewModel: TimerViewModel?
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func configure(with viewModel: TimerViewModel) {
        self.timerViewModel = viewModel
    }
    
    @objc private func handleDidEnterBackground() {
        timerViewModel?.pauseTimer()
    }
    
    @objc private func handleWillEnterForeground() {
        timerViewModel?.resumeTimer()
    }
}
