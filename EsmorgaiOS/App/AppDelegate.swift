import UIKit
import Firebase
import FirebaseCrashlytics

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        //Empty AppDelegate to avoid firbase config isuess
        NotificationServiceManager.shared.initialize(launchOptions: launchOptions)
        return true
    }
}
