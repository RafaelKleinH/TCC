
//
//  PersonalRegisterViewService.swift
//  OClock
//
//  Created by Rafael Hartmann on 08/01/22.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseDatabase

protocol PersonalRegisterViewServiceProtocol {
    func postInformations(name: String, occupation: String, image: UIImage) -> Observable<Bool>
}

class PersonalRegisterViewService: PersonalRegisterViewServiceProtocol {
    func postInformations(name: String, occupation: String, image: UIImage) -> Observable<Bool> {
        
        return Observable.create { observer in
            RFKDatabase().userDataBaseWithUID.updateChildValues(["name": name, "occupation": occupation, "profileImage": image]) { (error, db) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(true)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

