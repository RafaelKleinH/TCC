//
//  NotificationCentral.swift
//  OClock
//
//  Created by Rafael Hartmann on 10/03/22.
//

import Foundation
import UserNotifications
import UIKit

enum NotificationNames: String{
    case dailyNotification = "DailyNotf"
    case halfTime = "midTime"
    case totalTime = "totalTome"
    case totalInterval = "totalInterval"
    case extraHoursNotification = "extraNotify"
    case firstInterval = "firstInterval"
    case secondInterval = "secondInterval"
    case thirdInterval = "thirdInterval"
    case health = "helthNotf"
}

class NotificationsCentral {
    
    
    class func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            
        }
    }
    
    class func eliminateOthers() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    //MARK: normal funcs
    
    class func halfTimeNotification(time: Double, less: Double) {
        let realtime = time / 2 - less
        if realtime > 0 {
            let content = UNMutableNotificationContent()
            content.title = "NotificationHalfTimeTitle".localized()
            content.body = "NotificationHalfTimeMessage".localized()
            content.sound = .default
            if realtime > 0 {
                let timeinterval = TimeInterval(realtime)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeinterval, repeats: false)
                let request = UNNotificationRequest(identifier: NotificationNames.halfTime.rawValue, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    class func totalTimeNotification(time: Double, less: Double) {
        let realtime = time - less
        if realtime > 0 {
            let content = UNMutableNotificationContent()
            content.title = "NotificationTotalTimeTitle".localized()
            content.body = "NotificationTotalTimeMessage".localized()
            content.sound = .default
            let timeinterval = TimeInterval(realtime)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeinterval, repeats: false)
            let request = UNNotificationRequest(identifier: NotificationNames.totalTime.rawValue, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    class func extraHoursNotifications(time: Double, less: Double) {
        let realtime = time - less + 7200
        if realtime > 0 {
            let content = UNMutableNotificationContent()
            content.title = "NotificationExtraTimeTitle".localized()
            content.body = "NotificationExtraTimeMessage".localized()
            content.sound = .default
            let timeinterval = TimeInterval(realtime)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeinterval, repeats: false)
            let request = UNNotificationRequest(identifier: NotificationNames.extraHoursNotification.rawValue, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    class func healthIsOpen(healthIsOpen bool: Bool) {
        if bool {
           healthNormalNotifications()
        } else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [NotificationNames.health.rawValue])
        }
    }
    
    class func healthNormalNotifications() {
        let content = UNMutableNotificationContent()
        content.title = "NotificationHealthTitle".localized()
        content.body = "NotificationHealthMessage".localized()
        content.sound = .default
        let timeinterval = TimeInterval(60 * 30)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeinterval, repeats: true)
        let request = UNNotificationRequest(identifier: NotificationNames.health.rawValue, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: Health notifications
    
    class func calcNotifications(isOpen: Bool, time: Double, less: Double) {
        if isOpen {
            halfTimeNotification(time: time, less: less)
            totalTimeNotification(time: time, less: less)
            extraHoursNotifications(time: time, less: less)
            let value = UserDefaults.standard.bool(forKey: UserDefaultValue.HEALTH_IS_ON.rawValue)
            if value == true {
                healthNormalNotifications()
            }
        } else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [NotificationNames.halfTime.rawValue, NotificationNames.totalTime.rawValue])
        }
    }
    
    //MARK: interval Funcs
    
    class func intervalFirstNotification(intervalTime: Double, less: Double) {
        let realtime = (intervalTime - less) - (60 * 15)
        let content = UNMutableNotificationContent()
        content.title = "NotificationIntervalFirstEndingTimeTitle".localized()
        content.body = "NotificationIntervalFirstEndingTimeMessage".localized()
        content.sound = .default
        if realtime > 0 {
            let timeinterval = TimeInterval(realtime)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeinterval, repeats: false)
            let request = UNNotificationRequest(identifier: NotificationNames.firstInterval.rawValue, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    class func intervalSecondNotification(intervalTime: Double, less: Double) {
        let realtime = (intervalTime - less) - (60 * 5)
        let content = UNMutableNotificationContent()
        content.title = "NotificationIntervalSecondEndingTimeTitle".localized()
        content.body = "NotificationIntervalSecondEndingTimeMessage".localized()
        content.sound = .default
        if realtime > 0 {
            let timeinterval = TimeInterval(realtime)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeinterval, repeats: false)
            let request = UNNotificationRequest(identifier: NotificationNames.secondInterval.rawValue, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    class func intervalThirdNotification(intervalTime: Double, less: Double) {
        let realtime = intervalTime - less
        let content = UNMutableNotificationContent()
        content.title = "NotificationIntervalEndTimeTitle".localized()
        content.body = "NotificationIntervalEndTimeMessage".localized()
        content.sound = .default
        if realtime > 0 {
            let timeinterval = TimeInterval(realtime)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeinterval, repeats: false)
            let request = UNNotificationRequest(identifier: NotificationNames.thirdInterval.rawValue, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    class func intervalCalcNotifications(intervalIsOpen: Bool, time: Double, less: Double) {
        if intervalIsOpen {
            intervalFirstNotification(intervalTime: time, less: less)
            intervalSecondNotification(intervalTime: time, less: less)
            intervalThirdNotification(intervalTime: time, less: less)
        } else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [NotificationNames.firstInterval.rawValue, NotificationNames.secondInterval.rawValue, NotificationNames.thirdInterval.rawValue, NotificationNames.health.rawValue])
        }
    }
    
    //MARK: initial Func
    
    class func initialHourNotification(initHours: [Int]) {
        let content = UNMutableNotificationContent()
        content.title = "NotificationIntervalInitTimeTitle".localized()
        content.body = "NotificationIntervalInitTimeMessage".localized()
        content.sound = .default
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.hour = initHours.first
            if let minutes = initHours.last, let hour = dateComponents.hour{
                if (minutes - 15) < 0 {
                    dateComponents.hour = hour - 1
                    dateComponents.minute =  60 + (minutes - 15)
                } else {
                    dateComponents.minute = minutes - 15
                }
                print(dateComponents)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
                let uuidString = NotificationNames.dailyNotification.rawValue
                let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print(error.localizedDescription)
                }
            }
        }
    }
}
