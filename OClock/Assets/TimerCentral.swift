//
//  TimerCentral.swift
//  OClock
//
//  Created by Rafael Hartmann on 10/03/22.
//

import Foundation
import RxSwift
import Firebase
import FirebaseCore

class TimerCentral {
 
    //MARK: Common Vars
    
    let userDefaults = UserDefaults.standard
    var hasBreak: Bool?
    
    var initialTime: String?
       
    //MARK: Main Timer Vars
    var isOpen: Bool = false
    var timer: Timer?
    var timerNum: Int?
    var midTime = PublishSubject<Int>()

    var totalHours: Int?
    
    var startTime: Date?
    var stopTime: Date?
    
    let START_TIME_KEY = "startTime"
    let STOP_TIME_KEY = "stopTime"
    let COUNTING_KEY = "countingKey"
    
    var pauseFirstTime = true
    //MARK: Interval Timer Vars
    
    var intervalTimer: Timer?
    var intervalIsOpen: Bool = false
    var intervalTotalHours: Int?
    var intervalTimerNum: Int?
    var intervalMidTime = PublishSubject<Int>()
    
    var intervalStartTime: Date?
    var intervalStopTime: Date?
    
    let INTERVAL_START_TIME_KEY = "intervalStartTime"
    let INTERVAL_STOP_TIME_KEY = "intervalStopTime"
    let INTERVAL_COUNTING_KEY = "intervalCountingKey"
    
    
    //MARK: Main Timer Functions
    func startTimer() {
        if isOpen == false && (timerNum == 0 || timerNum == nil)  {
            let date = Date()
            let component = Calendar.current.dateComponents([.month, .weekday, .hour, .day, .minute, .second], from: date)
            initialTime = "\(component)"
        }
        if let stop = stopTime {
            let restartTime = calcRestartTime(start: startTime!, stop: stop)
            setStopTime(date: nil)
            setStartTime(date: restartTime)
        } else {
            setStartTime(date: Date())
        }
        
        startHelper()
        
    }
    
    func startHelper() {
        if timer?.isValid == nil || timer?.isValid == false {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(action), userInfo: nil, repeats: true)
            setTimerCounting(true)
            guard let time = totalHours else { return }
            let less = Double(timerNum ?? 0)
            NotificationsCentral.calcNotifications(isOpen: true, time: Double(time), less: less)
        }
    }

    func pauseTimer() {
        setStopTime(date: Date())
        stopTimer()
    }
    
    func stopTimer() {
        if let timer = timer {
            timer.invalidate()
        }
        setTimerCounting(false)
        guard let time = totalHours else { return }
        let less = Double(timerNum ?? 0)
        NotificationsCentral.calcNotifications(isOpen: false, time: Double(time), less: less)
    }
    
    
    func calcRestartTime(start: Date, stop: Date) -> Date {
        let diff = start.timeIntervalSince(stop)
        return Date().addingTimeInterval(diff)
    }
    
    @objc func action() {
        if let start = startTime {
            let diff = Date().timeIntervalSince(start)
            midTime.onNext(Int(diff))
            timerNum = Int(diff)
        }
        else {
            pauseTimer()
            midTime.onNext(0)
        }
    
    }
    
    func setStartTime(date: Date?) {
        startTime = date
        userDefaults.set(startTime, forKey: START_TIME_KEY)
    }
    
    func setStopTime(date: Date?) {
        stopTime = date
        userDefaults.set(stopTime, forKey: STOP_TIME_KEY)
    }
    
    func setTimerCounting(_ val: Bool) {
        isOpen = val
        userDefaults.set(isOpen, forKey: COUNTING_KEY)
    }
    
    func resetAction() {
        setStopTime(date: nil)
        setStartTime(date: nil)
        midTime.onNext(0)
        timerNum = 0
        stopTimer()
        
        intervalSetStopTime(date: nil)
        intervalSetStartTime(date: nil)
        intervalMidTime.onNext(0)
        intervalTimerNum = 0
        intervalStopTimer()
    }
    
    //MARK: Interval Timer Functions
    
    func intervalStartTimer() {
        if let stop = intervalStopTime {
            let restartTime = calcRestartTime(start: intervalStartTime!, stop: stop)
            intervalSetStopTime(date: nil)
            intervalSetStartTime(date: restartTime)
        } else {
            intervalSetStartTime(date: Date())
        }
        intervalStartHelper()
    }
    
    func intervalStartHelper() {
        if intervalTimer?.isValid == nil || intervalTimer?.isValid == false {
            intervalTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(intervalAction), userInfo: nil, repeats: true)
            intervalSetTimerCounting(true)
            guard let time = intervalTotalHours else { return }
            let less = Double(intervalTimerNum ?? 0)
            NotificationsCentral.intervalCalcNotifications(intervalIsOpen: true, time: Double(time), less: less)
        }
    }
    
    func intervalPauseTimer() {
        if intervalTimerNum != nil && intervalTimerNum != 0 {
            intervalSetStopTime(date: Date())
            intervalStopTimer()
        }
    }
    
    func intervalStopTimer() {
        if let timer = intervalTimer {
            timer.invalidate()
        }
        intervalSetTimerCounting(false)
        guard let time = intervalTotalHours else { return }
        let less = Double(intervalTimerNum ?? 0)
        NotificationsCentral.intervalCalcNotifications(intervalIsOpen: false, time: Double(time), less: less)
    }
    
    @objc func intervalAction() {
        if let start = intervalStartTime {
            let diff = Date().timeIntervalSince(start)
            intervalMidTime.onNext(Int(diff))
            intervalTimerNum = Int(diff)
        }
        else {
            intervalPauseTimer()
            intervalMidTime.onNext(0)
        }
    }
    
    func intervalSetStartTime(date: Date?) {
        intervalStartTime = date
        userDefaults.set(intervalStartTime, forKey: INTERVAL_START_TIME_KEY)
    }
    
    func intervalSetStopTime(date: Date?) {
        intervalStopTime = date
        userDefaults.set(intervalStopTime, forKey: INTERVAL_STOP_TIME_KEY)
    }
    
    func intervalSetTimerCounting(_ val: Bool) {
        intervalIsOpen = val
        userDefaults.set(intervalIsOpen, forKey: INTERVAL_COUNTING_KEY)
    }
    
    func saveDate() {
        
        let dbref = RFKDatabase()
        let date = Date()
        let component = Calendar.current.dateComponents([.month, .weekday, .hour, .day, .minute, .second], from: date)
        let componentOnlyNumber = "\(component)".removeCalendar()
        let componentInit = initialTime?.removeCalendar()
        
        var mounth = ""
        var initTime = ""
        var initDay = ""
        var initWeekDay = ""
        var endTime = ""
        var endDay = ""
        var endWeekDay = ""
        if componentOnlyNumber.count == 6 && componentInit?.count == 6, let componentInit = componentInit{
            mounth = componentInit[0]
            initTime = "\(componentInit[2]):\(componentInit[3]):\(componentInit[4])"
            initDay = componentInit[1]
            initWeekDay = componentInit[5]
            endDay = componentOnlyNumber[1]
            endTime = "\(componentOnlyNumber[2]):\(componentOnlyNumber[3]):\(componentOnlyNumber[4])"
            endWeekDay = componentOnlyNumber[5]
            
        }
        
        if let timerNum = timerNum, let initialTime = initialTime  {
            dbref.userReportDataBase.childByAutoId().updateChildValues(["month": mounth, "totalHours": timerNum, "initialHours": initTime, "initialDay": initDay, "initWeekday": initWeekDay, "intervalTotalHours": intervalTimerNum ?? 0, "endDay": endDay, "endHours": endTime, "endWeekday": endWeekDay]) {  _, _  in
                
            }
        }
    }
}


extension String {
    func removeCalendar() -> [String] {
        var valueA = self.replacingOccurrences(of: "month: ", with: "")
        valueA = valueA.replacingOccurrences(of: "day: ", with: ":")
        valueA = valueA.replacingOccurrences(of: "hour: ", with: ":")
        valueA = valueA.replacingOccurrences(of: "minute: ", with: ":")
        valueA = valueA.replacingOccurrences(of: "second: ", with: ":")
        valueA = valueA.replacingOccurrences(of: "week:", with: ":")
        valueA = valueA.replacingOccurrences(of: "weekday: ", with: ":")
        valueA = valueA.replacingOccurrences(of: " isLeapMonth: ", with: ":")
        valueA = valueA.replacingOccurrences(of: " ", with: "")
        valueA = valueA.replacingOccurrences(of: ":false", with: "")
        let valB = valueA.components(separatedBy: ":")
        return valB
    }
}

