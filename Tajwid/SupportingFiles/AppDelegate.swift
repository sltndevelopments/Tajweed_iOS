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

    lazy var bookService: BookService = BookServiceImplementation()
    lazy var tabBarControllersBuilder: TabBarControllersBuildable = TabBarControllersBuilder()
    lazy var mainTabBarController = MainTabBarController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        
        setupNavigationBarAppearance()
        askForPermissions()
        
        tabBarControllersBuilder.buildTabBarControllers(with: bookService, tabBarItemsBuilder: TabBarItemsBuilder()) { [unowned self] controllers in
            self.mainTabBarController.configuredTabBar(with: controllers)
            self.window?.rootViewController = mainTabBarController
            self.window?.makeKeyAndVisible()
        }
        
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
    
    // MARK: - Private helpers
    
    private func setupNavigationBarAppearance() {
        
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
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    private func askForPermissions() {
        let types: UIUserNotificationType = [.alert, .sound]
        let settings = UIUserNotificationSettings(types: types, categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
    }
    
}

