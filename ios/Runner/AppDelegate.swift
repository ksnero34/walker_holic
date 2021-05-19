import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    var flutter_native_splash = 1
    UIApplication.shared.isStatusBarHidden = false

    GeneratedPluginRegistrant.register(with: self)

    GMSServices.provideAPIKey("AIzaSyCe4YcYEeFhhbgnMAMdtREWDvzekV2b7_s")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}