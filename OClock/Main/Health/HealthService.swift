//
//  HealthService.swift
//  OClock
//
//  Created by Rafael Hartmann on 15/03/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol HealthServiceProtocol {
    
    func getIsOpen() -> Observable<Bool>
    
    func postIsOpen(value: Bool) -> Observable<Void>
}

class HealthService: HealthServiceProtocol {
    
    func getIsOpen() -> Observable<Bool> {
        return Observable.create { observer in
            let value = UserDefaults.standard.bool(forKey: UserDefaultValue.HEALTH_IS_ON.rawValue)
            observer.onNext(value)
            return Disposables.create()
        }
    }
    
    func postIsOpen(value: Bool) -> Observable<Void> {
        return Observable.create { observer in
            UserDefaults.standard.set(value,forKey: UserDefaultValue.HEALTH_IS_ON.rawValue)
            observer.onNext(())
            return Disposables.create()
        }
    }
}
