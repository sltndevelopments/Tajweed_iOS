//
//  Created by Tagir Nafikov on 04/02/2018.
//

import UIKit
import Firebase
import AVFoundation
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)

        UINavigationBar.appearance().tintColor = .greyishBrownTwo
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .whiteThree
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.greyishBrownTwo,
            .font: UIFont(name: FontNames.pn, size: 16) ?? UIFont()
        ]
        let backButton = #imageLiteral(resourceName: "back")
        UINavigationBar.appearance().backIndicatorImage = backButton
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButton
        
        askForPermissions()

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        LocalNotifcationsManager.createReminder()
        UserDefaults.standard.synchronize()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        LocalNotifcationsManager.createReminder()
        UserDefaults.standard.synchronize()
    }
    
    
    private func askForPermissions() {
        if #available(iOS 10.0, *) {
            let options: UNAuthorizationOptions = [.alert, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: options) { _, _ in
                
            }
        } else {
            let types: UIUserNotificationType = [.alert, .sound]
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    
}

