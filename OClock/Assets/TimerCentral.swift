//
//  TimerCentral.swift
//  OClock
//
//  Created by Rafael Hartmann on 10/03/22.
//

import Foundation
import RxSwift

class TimerCentral {
 
    //MARK: Common Vars
    
    let userDefaults = UserDefaults.standard
    var hasBreak: Bool?
    
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
    
    //MARK: Interval Timer Vars
    
    var intervalTimer: Timer?
    var intervalIsOpen: Bool = false
    var intervalTotalHours: Int?
    var intervalTimerNum: Int?
    
    var intervalStartTime: Date?
    var intervalStopTime: Date?
    
    let INTERVAL_START_TIME_KEY = "intervalStartTime"
    let INTERVAL_STOP_TIME_KEY = "intervalStopTime"
    let INTERVAL_COUNTING_KEY = "intervalCountingKey"
    
    
    //MARK: Main Timer Functions
    func startTimer() {
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
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(action), userInfo: nil, repeats: true)
        setTimerCounting(true)
        guard let time = totalHours else { return }
        let less = Double(timerNum ?? 0)
        NotificationsCentral.calcNotifications(isOpen: true, time: Double(time), less: less)
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
        stopTimer()
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
        intervalTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(intervalAction), userInfo: nil, repeats: true)
        intervalSetTimerCounting(true)
        guard let time = intervalTotalHours else { return }
        let less = Double(intervalTimerNum ?? 0)
        NotificationsCentral.intervalCalcNotifications(intervalIsOpen: true, time: Double(time), less: less)
    }
    
    func intervalPauseTimer() {
        intervalSetStopTime(date: Date())
        intervalStopTimer()
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
            //midTime.onNext(Int(diff))
            intervalTimerNum = Int(diff)
        }
        else {
            intervalPauseTimer()
            //midTime.onNext(0)
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
}
