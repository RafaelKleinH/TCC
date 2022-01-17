//
//  HomeViewService.swift
//  OClock
//
//  Created by Rafael Hartmann on 14/01/22.
//

import Foundation
import RxSwift
import FirebaseAuth
import FirebaseFirestore

protocol HomeViewServiceProtocol {
    func largato() -> Observable<PersonalData?>
}

class HomeViewService: HomeViewServiceProtocol {
    
    func largato() -> Observable<PersonalData?> {
        
        return Observable.create { observer in
            RFKDatabase().userDataBaseWithUID.getData  { (error, document) in
                if let error = error {
                    observer.onError(error)
                } else {
                    if let data = document.value as? [String: Any] {
                        let prData = PersonalData(dictionary: data)
                        observer.onNext(prData)
                    }
                }
            }
            return Disposables.create()
        }
    }
}

    
