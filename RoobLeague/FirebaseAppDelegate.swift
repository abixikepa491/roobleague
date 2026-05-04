import FirebaseAnalytics
import FirebaseCore
import FirebaseMessaging
import UIKit
import UserNotifications

@MainActor
final class FirebaseAppDelegate: NSObject, UIApplicationDelegate, @preconcurrency UNUserNotificationCenterDelegate, @preconcurrency MessagingDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        let didConfigureFirebase = configureFirebaseIfPossible()

        guard didConfigureFirebase else { return true }

        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            guard granted else { return }
            Task { @MainActor in
                application.registerForRemoteNotifications()
            }
        }
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken else { return }
        NotificationCenter.default.post(name: .firebaseFCMTokenDidChange, object: fcmToken)
        #if DEBUG
        print("Firebase FCM token: \(fcmToken)")
        #endif
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .badge, .sound, .list]
    }

    private func configureFirebaseIfPossible() -> Bool {
        guard FirebaseApp.app() == nil else { return true }

        if let options = firebaseOptions() {
            FirebaseApp.configure(options: options)
            Analytics.setAnalyticsCollectionEnabled(true)
            return true
        }

        #if DEBUG
        print("Firebase skipped: GoogleService-Info.plist is missing from the app bundle.")
        #endif
        return false
    }

    private func firebaseOptions() -> FirebaseOptions? {
        guard let configPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
            return nil
        }
        return FirebaseOptions(contentsOfFile: configPath)
    }
}

extension Notification.Name {
    static let firebaseFCMTokenDidChange = Notification.Name("firebaseFCMTokenDidChange")
}
