//
//  TimeDataRegisterViewService.swift
//  OClock
//
//  Created by Rafael Hartmann on 08/01/22.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseDatabase

protocol TimeDataRegisterViewServiceProtocol {
    func postInformations(totalH: String, hasBreak: Bool, breakTime: String, startTime: String) -> Observable<Bool>
}

class TimeDataRegisterViewService: TimeDataRegisterViewServiceProtocol {
    func postInformations(totalH: String, hasBreak: Bool, breakTime: String, startTime: String) -> Observable<Bool> {
        
        return Observable.create { observer in
            RFKDatabase().userHoursDataBaseWithUID.updateChildValues(["totalHours": totalH, "hasBreak": hasBreak, "breakTime": breakTime, "sttartHour": startTime]) { (error, db) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(true)
                    UserDefaults.standard.set(true, forKey: UserDefaultValue.NEED_RELOAD.rawValue)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
