//
//  RegisterViewService.swift
//  OClock
//
//  Created by Rafael Hartmann on 04/01/22.
//

import Foundation
import RxSwift
import FirebaseAuth

protocol RegisterViewServiceProtocol  {
    func registerUser(email: String, password: String) -> Observable<(AuthDataResult?)>
}

class RegisterViewService: RegisterViewServiceProtocol {
    
    func registerUser(email: String, password: String) -> Observable<(AuthDataResult?)> {
        return Observable.create { observer in
            Auth.auth().createUser(withEmail: email, password: password) { (authData, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(authData)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
