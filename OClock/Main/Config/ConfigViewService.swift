//
//  ConfigViewService.swift
//  OClock
//
//  Created by Rafael Hartmann on 27/01/22.
//

import Foundation
import RxSwift

protocol ConfigViewServiceProtocol {
    func logoff() -> Observable<Void>
}

class ConfigViewService: ConfigViewServiceProtocol {
    func logoff() -> Observable<Void> {
        return Observable.create { observer in
            UserDefaults.standard.removeObject(forKey: UserDefaultValue.logged.rawValue)
            UserDefaults.standard.removeObject(forKey: UserDefaultValue.userMail.rawValue)
            UserDefaults.standard.removeObject(forKey: UserDefaultValue.userPassword.rawValue)
            UserDefaults.standard.removeObject(forKey: UserDefaultValue.START_TIME_KEY.rawValue)
            UserDefaults.standard.removeObject(forKey: UserDefaultValue.STOP_TIME_KEY.rawValue)
            UserDefaults.standard.removeObject(forKey: UserDefaultValue.COUNTING_KEY.rawValue)
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
