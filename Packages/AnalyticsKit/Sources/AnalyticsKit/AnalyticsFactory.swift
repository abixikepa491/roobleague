import Foundation
#if canImport(AVFoundation)
import AVFoundation
#endif
import WebKit
#if canImport(UIKit)
import UIKit
#endif

public enum AnalyticsFactory {
    public static func makeConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        #if os(iOS)
        configuration.allowsInlineMediaPlayback = true
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.allowsPictureInPictureMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        #endif
        if #available(iOS 14.0, macOS 11.0, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                configuration.defaultWebpagePreferences.preferredContentMode = .desktop
            }
            #endif
        } else {
            configuration.preferences.javaScriptEnabled = true
        }
        return configuration
    }

    public static func prewarm(url: URL, timeout: TimeInterval = 8) {
        let webView = WKWebView(frame: .zero, configuration: makeConfiguration())
        webView.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: timeout))
    }

    #if canImport(AVFoundation) && os(iOS)
    @MainActor
    public static func prepareForMediaPlaybackIfNeeded() {
        activatePlaybackAudioSessionIfNeeded()
    }
    #endif

    #if canImport(AVFoundation) && os(iOS)
    private static func activatePlaybackAudioSessionIfNeeded() {
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            #if DEBUG
            print("AnalyticsFactory audio session activation failed: \(error)")
            #endif
        }
    }
    #endif
}
