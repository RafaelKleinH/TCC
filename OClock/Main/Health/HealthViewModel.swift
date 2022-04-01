//
//  HealthViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 15/03/22.
//

import Foundation
import RxSwift

protocol HealthViewModelProtocol {
    var timerCentral: TimerCentral { get }
    var myDisposeBag: DisposeBag { get }
    
    var isOpen: Bool { get set }
}

class HealthViewModel: HealthViewModelProtocol {
    
    var isOpen = false
    var timerCentral: TimerCentral
    
    let myDisposeBag = DisposeBag()
    
    init(timerCentral: TimerCentral, service: HealthServiceProtocol = HealthService()) {
        self.timerCentral = timerCentral
    }
}
