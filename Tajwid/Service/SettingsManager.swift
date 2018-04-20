//
//  Created by Tagir Nafikov on 20/04/2018.
//

import Foundation


final class SettingsManager {
    
    // MARK: - Constants
    
    private enum Constants {
        static let isReminderEnabledKey = "isReminderEnabledKey"
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
    
}
