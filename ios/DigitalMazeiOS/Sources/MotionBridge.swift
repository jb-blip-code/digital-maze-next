import CoreMotion
import Foundation
import WebKit

final class MotionBridge {
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()
    private weak var webView: WKWebView?

    init(webView: WKWebView) {
        self.webView = webView
    }

    func start() {
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0

        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: queue) { [weak self] motion, _ in
            guard
                let self,
                let motion,
                let webView = self.webView
            else { return }

            // Roll/Pitch mapped to game tilt input range [-1, 1]
            let x = max(-1.0, min(1.0, motion.attitude.roll / 0.55))
            let y = max(-1.0, min(1.0, motion.attitude.pitch / 0.75))

            let js = "window.setNativeTilt(\(x), \(y));"
            DispatchQueue.main.async {
                webView.evaluateJavaScript(js, completionHandler: nil)
            }
        }
    }

    func stop() {
        motionManager.stopDeviceMotionUpdates()
        webView?.evaluateJavaScript("window.clearNativeTilt && window.clearNativeTilt();", completionHandler: nil)
    }
}
