import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Leia a chave do Info.plist (GoogleMapsApiKey). Não deixe hardcoded.
    if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
       let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
       let apiKey = dict["GoogleMapsApiKey"] as? String, !apiKey.isEmpty {
      GMSServices.provideAPIKey(apiKey)
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
