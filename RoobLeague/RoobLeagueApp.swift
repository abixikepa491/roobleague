import SwiftUI
import AnalyticsKit

@main
struct RoobLeagueApp: App {
    @UIApplicationDelegateAdaptor(FirebaseAppDelegate.self) private var firebaseAppDelegate
    @StateObject private var appModel = AppModel()
    private let analyticsConfig = AnalyticsLaunchConfig(
        serverDomain: "luckyapp.live",
        analyticsToken: "dd06b3b3229cc3ded2e37dd14a3e29bdf71a0d80c5dd7ec2fac40f79100dd721",
        bundleID: "com.roobleague.app"
    )

    var body: some Scene {
        WindowGroup {
            AnalyticsEntry(config: analyticsConfig, requestReviewBeforeCheck: false) {
                RootView()
                    .environmentObject(appModel)
                    .preferredColorScheme(.dark)
            }
        }
    }
}
