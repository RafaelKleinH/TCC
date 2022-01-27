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
    func LoginUser(email: String, password: String, saveUser: Bool) -> Observable<(AuthDataResult?)>
    
    func getUserDefaults() -> Observable<PersonalModel>
}

class LoginViewService: LoginViewServiceProtocol {
    func saveUser(email: String, password: String) {
        UserDefaults.standard.set(true, forKey: UserDefaultValue.logged.rawValue)
        UserDefaults.standard.set(email, forKey: UserDefaultValue.userMail.rawValue)
        UserDefaults.standard.set(password, forKey: UserDefaultValue.userPassword.rawValue)
    }
    
    func getUserDefaults() -> Observable<PersonalModel> {
        return Observable.create { observer in
            let mail = UserDefaults.standard.string(forKey: UserDefaultValue.userMail.rawValue) ?? ""
            let password = UserDefaults.standard.string(forKey: UserDefaultValue.userPassword.rawValue) ?? ""
            
            observer.onNext(PersonalModel(mail: mail, password: password))
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func LoginUser(email: String, password: String, saveUser: Bool)  -> Observable<(AuthDataResult?)> {
        return Observable.create { observer in
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authdata, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    self?.saveUser(email: email, password: password)
                    observer.onNext(authdata)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
  

