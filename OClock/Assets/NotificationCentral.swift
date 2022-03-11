//
//  NotificationCentral.swift
//  OClock
//
//  Created by Rafael Hartmann on 10/03/22.
//

import Foundation
import UserNotifications

class NotificationsCentral {
    
    
    class func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            
        }
    }
    
    class func eliminateOthers() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    class func normalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Passou metade do seu periodo"
        content.body = "Voce ja fez metade do seu horario previsto :D."
        let date = Date().addingTimeInterval(5)
        let dateComp = Calendar.current.dateComponents([.year, .day, .minute, .hour, .minute, .second], from: date)
        let uuidString = UUID().uuidString
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
   
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
            } else {
                print("salve")
            }
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
            
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error)
                } else {
                    print("salve")
                }
            }
        }
        
        
    }
}
