//
//  Created by Tagir Nafikov on 20/04/2018.
//

import UIKit


final class SettingsManager {
    
    // MARK: - Constants
    
    private enum Constants {
        static let isReminderEnabledKey = "isReminderEnabledKey"
        static let fontSizeAdditionKey = "fontSizeAdditionKey"
        static let mainFontNameKey = "mainFontNameKey"
    }
    
    
    // MARK: - Class public properties
    
    static var isReminderEnabled: Bool {
        get {
            let haveValue = UserDefaults.standard.value(forKey: Constants.isReminderEnabledKey) != nil
            return haveValue ? UserDefaults.standard.bool(forKey: Constants.isReminderEnabledKey) : true
        } set {
            UserDefaults.standard.set(newValue, forKey: Constants.isReminderEnabledKey)
            if !newValue { LocalNotifcationsManager.cancelReminders() }
        }
    }
    
    static var fontSizeAddition: CGFloat {
        get {
            return CGFloat(UserDefaults.standard.float(forKey: Constants.fontSizeAdditionKey))
        } set {
            UserDefaults.standard.set(Float(newValue), forKey: Constants.fontSizeAdditionKey)
        }
    }

    static var mainFontName: String? {
        get {
            return UserDefaults.standard.value(forKey: Constants.mainFontNameKey) as? String
        } set {
            UserDefaults.standard.set(newValue, forKey: Constants.mainFontNameKey)
        }
    }

}
