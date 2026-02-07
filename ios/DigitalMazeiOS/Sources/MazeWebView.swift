import SwiftUI
import WebKit

struct MazeWebView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.bounces = false
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .black
        webView.isOpaque = false

        context.coordinator.attach(webView: webView)
        context.coordinator.loadGame(into: webView)

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    static func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
        coordinator.stopMotion()
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        private var motionBridge: MotionBridge?

        func attach(webView: WKWebView) {
            webView.navigationDelegate = self
            motionBridge = MotionBridge(webView: webView)
        }

        func loadGame(into webView: WKWebView) {
            guard
                let htmlURL = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "www")
            else {
                webView.loadHTMLString("<h1 style='color:white;font-family:-apple-system'>Missing www/index.html in bundle</h1>", baseURL: nil)
                return
            }

            let baseURL = htmlURL.deletingLastPathComponent()
            webView.loadFileURL(htmlURL, allowingReadAccessTo: baseURL)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            motionBridge?.start()
        }

        func stopMotion() {
            motionBridge?.stop()
        }
    }
}
