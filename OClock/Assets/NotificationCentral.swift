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
    
    class func halfTimeNotification(time: Double, less: Double) {
        let realtime = time / 2 - less
        let content = UNMutableNotificationContent()
        content.title = "Passou metade do seu periodo"
        content.body = "Voce ja fez metade do seu horario previsto :D."
        let timeinterval = TimeInterval(realtime)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeinterval, repeats: false)
        let request = UNNotificationRequest(identifier: NotificationNames.halfTime.rawValue, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    class func totalTimeNotification(time: Double, less: Double) {
        let realtime = time - less
        let content = UNMutableNotificationContent()
        content.title = "Acaboooou!"
        content.body = "Voce terminou seu expediente, seja livre meu amigo."
        let timeinterval = TimeInterval(realtime)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeinterval, repeats: false)
        let request = UNNotificationRequest(identifier: NotificationNames.totalTime.rawValue, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    class func extraHoursNotifications(time: Double, less: Double) {
        let realtime = time - less + 7200
        let content = UNMutableNotificationContent()
        content.title = "Não se mate"
        content.body = "Ei meu rei não vá se matar"
        let timeinterval = TimeInterval(realtime)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeinterval, repeats: false)
        let request = UNNotificationRequest(identifier: NotificationNames.extraHoursNotification.rawValue, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    class func calcNotifications(isOpen: Bool, time: Double, less: Double) {
        if isOpen {
            halfTimeNotification(time: time, less: less)
            totalTimeNotification(time: time, less: less)
            extraHoursNotifications(time: time, less: less)
        } else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [NotificationNames.halfTime.rawValue, NotificationNames.totalTime.rawValue])
        }
        
    }
    
    
    class func initialHourNotification(initHours: [Int]) {
        let content = UNMutableNotificationContent()
        content.title = "Hora de trabalhar!"
        content.body = "Falta 15 minutos para seu horario de trabalho."
        
        var dateComponents = DateComponents()
        for i in 2...6 {
            dateComponents.weekday = i
            dateComponents.hour = initHours.first
            if let minutes = initHours.last {
                dateComponents.minute = minutes - 15
            }
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let uuidString = "DailyNotf"
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
