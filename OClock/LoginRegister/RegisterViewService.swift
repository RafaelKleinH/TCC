//
//  RegisterViewService.swift
//  OClock
//
//  Created by Rafael Hartmann on 04/01/22.
//

import Foundation
import RxSwift
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

protocol RegisterViewServiceProtocol  {
    func registerUser(email: String, password: String) -> Observable<(AuthDataResult?)>
}

class RegisterViewService: RegisterViewServiceProtocol {
    
    func registerUser(email: String, password: String) -> Observable<(AuthDataResult?)> {
        return Observable.create { observer in
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (authData, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    self?.createBasicData(uid: authData?.user.uid)
                    observer.onNext(authData)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func createBasicData(uid: String?) {
        RFKDatabase().userDataBaseWithUID.updateChildValues(["name": "", "occupation": "", "profileImage": ""])
    }
}
