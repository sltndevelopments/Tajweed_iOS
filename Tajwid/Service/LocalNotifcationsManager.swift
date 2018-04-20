//
//  Created by Tagir Nafikov on 18/04/2018.
//

import UIKit
import UserNotifications


final class LocalNotifcationsManager {
    
    // MARK: - Constants
    
    private enum Constants {
        static let intervalToReminder = TimeInterval(/*604800*/86400)
        static let intervalInCurrentDay = TimeInterval(68400)
    }
    
    
    // MARK: - Public class methods
    static func createReminder() {
        if !SettingsManager.isReminderEnabled { return }
        
        if #available(iOS 10.0, *) {
            createReminderUNNotificationRequests()
        } else {
            createReminderUILocalNotifications()
        }
    }
    
    static func createReminderUILocalNotifications() {
        UIApplication.shared.cancelAllLocalNotifications()
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = reminderDate()
        localNotification.alertBody = "Вы давно не учили Таджвид."
        localNotification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    static func createReminderUNNotificationRequests() {
        if #available(iOS 10.0, *) {
            let notificationsCenter = UNUserNotificationCenter.current()
            notificationsCenter.removeAllPendingNotificationRequests()
            
            let content = UNMutableNotificationContent()
            content.body = "Вы давно не учили Таджвид."
            content.sound = UNNotificationSound.default()
            
            let dateComponents = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute, .second],
                from: reminderDate())
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "tajwid-reminder",
                content: content,
                trigger: trigger)
            
            notificationsCenter.add(request, withCompletionHandler: nil)
        }
    }
    
    static func cancelReminders() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        } else {
            UIApplication.shared.cancelAllLocalNotifications()
        }
    }
    
    
    // MARK: - Private class methods
    
    private static func reminderDate() -> Date {
        var date = Calendar.current.startOfDay(for: Date())
        date = date.addingTimeInterval(Constants.intervalInCurrentDay)
        return date.addingTimeInterval(Constants.intervalToReminder)
    }
    
}
