//
//  RegisterViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 17/11/21.
//

import Foundation
import RxSwift
import UIKit
import FirebaseAuth

enum RegisterState {
    case error(_:String)
    case data
    case loading
}

protocol RegisterViewModelProtocol {
    typealias Target = RegisterViewCoordinator.Target

    var emailTextFieldPlaceholder: Observable<String> { get }
    var passwordTextFieldPlaceholder: Observable<String> { get }
    var confirmPasswordTextFieldPlaceholder: Observable<String> { get }
    var registerButtonTitle: Observable<String> { get }
    
    var emailText: AnyObserver<String>  { get }
    var passwordText: AnyObserver<String>  { get }
    var confirmPasswordText: AnyObserver<String> { get }
    
    var navigationTarget: Observable<Target> { get }
    var didTapNavigationBackButtom: AnyObserver<Void> { get }
    var didTapRegisterButton: AnyObserver<Void> { get }
    
    var state: Observable<RegisterState> { get }

    var myDisposeBag: DisposeBag { get }
    
    var register: Observable<AuthDataResult?> { get }
}

class RegisterViewModel: RegisterViewModelProtocol {
    
    let emailTextFieldPlaceholder: Observable<String> = .just("RegisterEmailTF".localized())
    let passwordTextFieldPlaceholder: Observable<String> = .just("RegisterPasswordTF".localized())
    let confirmPasswordTextFieldPlaceholder: Observable<String> = .just("RegisterConfirmPasswordTF".localized())
    let registerButtonTitle: Observable<String> = .just("RegisterButton".localized())
    
    let navigationTarget: Observable<Target>
    
    let state: Observable<RegisterState>
    
    let emailText: AnyObserver<String>
    let passwordText: AnyObserver<String>
    let confirmPasswordText: AnyObserver<String>
    
    let didTapNavigationBackButtom: AnyObserver<Void>
    let didTapRegisterButton: AnyObserver<Void>
    
    let myDisposeBag = DisposeBag()
    
    let register: Observable<AuthDataResult?>
    
    init(service: RegisterViewServiceProtocol = RegisterViewService()) {
        
        let _didTapNavigationBackButtom = PublishSubject<Void>()
        didTapNavigationBackButtom = _didTapNavigationBackButtom.asObserver()
        
        let _didTapRegisterButton = PublishSubject<Void>()
        didTapRegisterButton = _didTapRegisterButton.asObserver()
        
        let _emailText = PublishSubject<String>()
        emailText = _emailText.asObserver()
        
        let _passwordText = PublishSubject<String>()
        passwordText = _passwordText.asObserver()
        
        let _confirmPasswordText = PublishSubject<String>()
        confirmPasswordText = _confirmPasswordText.asObserver()
        
        let _state = PublishSubject<RegisterState>()
        state = _state.asObserver()
        
        register = _didTapRegisterButton
            .withLatestFrom(Observable.combineLatest(_emailText, _passwordText, _confirmPasswordText))
            .filter({ _, password, confirmPassword in
                 password == confirmPassword
            })
            .flatMapLatest { email, password, _ in
                service.registerUser(email: email, password: password)
                    .asObservable()
                    .observe(on: MainScheduler.instance)
                    .do(onNext: { _ in  _state.onNext(.data) },
                        onSubscribe: { _state.onNext(.loading) })
                    .catchError { error in
                        _state.onNext(.error(error.localizedDescription))
                        return Observable.empty()
                    }
            }.share()
            
        
        navigationTarget = Observable.merge(
            _didTapNavigationBackButtom.map { .pop }
        )
    }
}
