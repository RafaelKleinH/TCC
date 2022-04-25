//
//  UserDefaultValue.swift
//  OClock
//
//  Created by Rafael Hartmann on 18/01/22.
//

import Foundation

enum UserDefaultValue: String{
    case logged = "isUserLoggedIn"
    case userMail = "UserMail"
    case userPassword = "UserPassword"
    case START_TIME_KEY = "startTime"
    case STOP_TIME_KEY = "stopTime"
    case COUNTING_KEY = "countingKey"
    case profile_image = "profImg"
    case NEED_RELOAD = "needReload"
    case INTERVAL_START_TIME_KEY = "intervalStartTime"
    case INTERVAL_STOP_TIME_KEY = "intervalStopTime"
    case INTERVAL_COUNTING_KEY = "intervalCountingKey"
    case HEALTH_IS_ON = "healthIsOn"
}
