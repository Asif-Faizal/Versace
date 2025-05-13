import Flutter
import UIKit
import Foundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let CHANNEL = "com.example.versace/device"
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)
    
    channel.setMethodCallHandler { [weak self] (call, result) in
      guard let self = self else { return }
      
      if call.method == "getDeviceInfo" {
        let deviceInfo: [String: Any] = [
          "deviceId": UIDevice.current.identifierForVendor?.uuidString ?? "",
          "model": UIDevice.current.model,
          "manufacturer": "Apple",
          "os": "iOS",
          "osVersion": UIDevice.current.systemVersion
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: deviceInfo),
           let jsonString = String(data: jsonData, encoding: .utf8) {
          result(jsonString)
        } else {
          result(FlutterError(code: "SERIALIZATION_ERROR",
                            message: "Failed to serialize device info",
                            details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
