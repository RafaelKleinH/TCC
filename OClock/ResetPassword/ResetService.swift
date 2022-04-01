//
//  ResetService.swift
//  OClock
//
//  Created by Rafael Hartmann on 25/03/22.
//

import Foundation
import FirebaseAuth
import RxSwift

protocol ResetServiceProtocol {
    func resetEmail(with email: String) -> Observable<Void> 
}

class ResetService: ResetServiceProtocol  {
    
    func resetEmail(with email: String) -> Observable<Void> {
        return Observable.create { observer in
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(())
                }
                observer.onCompleted()
                
            }
            return Disposables.create()
        }
    }
}
