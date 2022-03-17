//
//  HealthViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 15/03/22.
//

import Foundation

protocol HealthViewModelProtocol {
    var timerCentral: TimerCentral { get }
}

class HealthViewModel: HealthViewModelProtocol {
    
    var timerCentral: TimerCentral
    
    init(timerCentral: TimerCentral, service: HealthServiceProtocol = HealthService()) {
        self.timerCentral = timerCentral
    }
}
