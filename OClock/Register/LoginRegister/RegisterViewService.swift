//
//  RegisterViewService.swift
//  OClock
//
//  Created by Rafael Hartmann on 04/01/22.
//

import Foundation
import Firebase
import RxSwift

protocol RegisterViewServiceProtocol  {
    func registerUser(email: String, password: String) -> Single<(Bool)>
}

class RegisterViewService: RegisterViewServiceProtocol {
    
    func registerUser(email: String, password: String)  -> Single<(Bool)> {
        
        var teste = false
        var testes = ""
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                testes = error.localizedDescription
            } else {
                teste = true
            }
        }
        return Single.just((teste))
    }
}
