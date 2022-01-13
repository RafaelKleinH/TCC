//
//  LoginViewService.swift
//  OClock
//
//  Created by Rafael Hartmann on 08/01/22.
//

import Foundation
import Firebase
import RxSwift

protocol LoginViewServiceProtocol  {
    func LoginUser(email: String, password: String) -> Observable<(AuthDataResult?)>
}

class LoginViewService: LoginViewServiceProtocol {
    
    func LoginUser(email: String, password: String)  -> Observable<(AuthDataResult?)> {
        return Observable.create { observer in
            Auth.auth().signIn(withEmail: email, password: password) { (authdata, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(authdata)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
  
