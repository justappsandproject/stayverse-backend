import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {


    //TODO: Enter API key for the "Maps SDK for iOS"
    GMSServices.provideAPIKey("AIzaSyBMwWnkjChuojxMkGuH1OdfTQXotV3URZQ")


    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
