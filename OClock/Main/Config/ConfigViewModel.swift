//
//  ConfigViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 18/01/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol ConfigViewModelProtocol {
    var timer: Observable<Int> { get }
}
class ConfigViewModel: ConfigViewModelProtocol {
    
    let timer: Observable<Int>
    
    init() {
    
        var next = 0
    
        timer = Observable.create { observer in
            
            let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
            timer.schedule(deadline: .now(), repeating: 1)
            
            
            
            timer.setEventHandler {
                observer.onNext(next)
                next += 1
            }
            timer.resume()
            
            return Disposables.create()
        }
        
        
    }
}
