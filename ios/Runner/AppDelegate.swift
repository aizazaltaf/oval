import Flutter
import UIKit
import AVFoundation
import flutter_local_notifications


@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
   FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
          GeneratedPluginRegistrant.register(with: registry)
      }
if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
}
    let controller = window?.rootViewController as! FlutterViewController
          let speakerphoneChannel = FlutterMethodChannel(
              name: "speakerphone_control",
              binaryMessenger: controller.binaryMessenger
          )

          speakerphoneChannel.setMethodCallHandler { (call, result) in
              if call.method == "setSpeakerphoneOn" {
                  if let enable = call.arguments as? Bool {
                      self.setSpeakerphoneOn(enable)
                      result(nil)
                  } else {
                      result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid argument", details: nil))
                  }
              } else if call.method == "getSpeakerphoneStatus" {
                  let isSpeakerOn = self.getSpeakerphoneStatus()
                  result(isSpeakerOn)
              } else {
                  result(FlutterMethodNotImplemented)
              }
          }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    super.applicationDidBecomeActive(application)
    // Ensure audio session is properly configured when app becomes active
    configureAudioSession()
  }
  
  private func configureAudioSession() {
    do {
      let audioSession = AVAudioSession.sharedInstance()
      try audioSession.setCategory(.playback, mode: .default, options: [.allowBluetooth, .defaultToSpeaker])
      try audioSession.setActive(true)
      print("Audio session configured successfully")
    } catch {
      print("Error configuring audio session: \(error.localizedDescription)")
    }
  }

    private func setSpeakerphoneOn(_ enable: Bool) {
        print("Setting speakerphone: \(enable)")
        do {
            let audioSession = AVAudioSession.sharedInstance()
            
            if enable {
                // Configure audio session for speaker output
                print("Configuring audio session for speaker output")
                try audioSession.setCategory(.playback, mode: .default, options: [.allowBluetooth, .defaultToSpeaker])
                try audioSession.setActive(true)
                // Add a small delay to ensure the audio session is properly configured
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    do {
                        try audioSession.overrideOutputAudioPort(.speaker)
                        print("Successfully set output audio port to speaker")
                    } catch {
                        print("Error overriding output audio port: \(error.localizedDescription)")
                    }
                }
            } else {
                // Configure audio session for earpiece output
                print("Configuring audio session for earpiece output")
                try audioSession.setCategory(.playback, mode: .default, options: [.allowBluetooth])
                try audioSession.setActive(true)
                try audioSession.overrideOutputAudioPort(.none)
                print("Successfully set output audio port to earpiece")
            }
        } catch {
            print("Error setting speakerphone: \(error.localizedDescription)")
        }
    }
    
    private func getSpeakerphoneStatus() -> Bool {
        let audioSession = AVAudioSession.sharedInstance()
        let currentRoute = audioSession.currentRoute
        
        // Check if the current output port is speaker
        for output in currentRoute.outputs {
            if output.portType == .builtInSpeaker {
                print("Speaker is currently ON")
                return true
            }
        }
        
        print("Speaker is currently OFF")
        return false
    }
    
}
