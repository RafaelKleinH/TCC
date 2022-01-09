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
    func LoginUser(email: String, password: String) -> Single<Bool>
}

class LoginViewService: LoginViewServiceProtocol {
    
    func LoginUser(email: String, password: String)  -> Single<Bool> {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authData, error) in
            if let error = error {
                print("Error")
            } else {
                print("dalhe")
            }
        }
        
        return Single.just(true)
    }
}
