import EventKit
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        requestCalendarAccess()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func requestCalendarAccess() {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                print("Calendar access granted")
            } else {
                print("Calendar access denied or error occurred: \(error?.localizedDescription ?? "Unknown Error")")
            }
        }
    }
}
