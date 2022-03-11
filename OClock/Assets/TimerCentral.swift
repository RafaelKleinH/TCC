//
//  TimerCentral.swift
//  OClock
//
//  Created by Rafael Hartmann on 10/03/22.
//

import Foundation
import RxSwift

class TimerCentral {
    
    var isOpen: Bool = false
    var timer: Timer?
    var timerNum: Int?
    var midTime = PublishSubject<Int>()
    
    var hasBreak: Bool?
    var totalHours: Int?
    
    let userDefaults = UserDefaults.standard
    var startTime: Date?
    var stopTime: Date?
    
    let START_TIME_KEY = "startTime"
    let STOP_TIME_KEY = "stopTime"
    let COUNTING_KEY = "countingKey"
    
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
            print(start)
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
    
}
