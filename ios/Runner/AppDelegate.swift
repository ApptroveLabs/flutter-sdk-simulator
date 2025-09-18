import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let appleSearchAdsChannel = FlutterMethodChannel(name: "apple_search_ads",
                                                    binaryMessenger: controller.binaryMessenger)
    appleSearchAdsChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "getAttributionToken" {
        let token = AppleSearchAdsHelper.getAttributionToken()
        result(token)
      } else if call.method == "requestTrackingAuthorization" {
        AppleSearchAdsHelper.requestTrackingAuthorization { authorized in
          result(authorized)
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
