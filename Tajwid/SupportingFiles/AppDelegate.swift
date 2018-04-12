//
//  Created by Tagir Nafikov on 04/02/2018.
//

import UIKit
import Fabric
import Crashlytics
import AVFoundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
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

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        UserDefaults.standard.synchronize()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.synchronize()
    }

}

