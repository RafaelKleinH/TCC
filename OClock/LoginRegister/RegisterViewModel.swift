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

enum RegisterTFState {
    case isEmptyF
    case isEmptyS
    case isEmptyT
    case passwordDoesntMatch
    case emailInvalid
    case passwordLessThanSixCharacters
    case success
}

protocol RegisterViewModelProtocol {
    typealias Target = RegisterViewCoordinator.Target

    var emailTextFieldPlaceholder: Observable<String> { get }
    var passwordTextFieldPlaceholder: Observable<String> { get }
    var confirmPasswordTextFieldPlaceholder: Observable<String> { get }
    var registerButtonTitle: Observable<String> { get }
    var tfReturn: Observable<Void> { get }
    var emailText: AnyObserver<String>  { get }
    var passwordText: AnyObserver<String>  { get }
    var confirmPasswordText: AnyObserver<String> { get }
    
    var navigationTarget: Observable<Target> { get }
    var didTapNavigationBackButtom: AnyObserver<Void> { get }
    var didTapRegisterButton: AnyObserver<Void> { get }
    var didReturnTFValidation: AnyObserver<Void> { get }
    
    var state: Observable<RegisterState> { get }
    var tfState: Observable<RegisterTFState> { get }

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
    let tfState: Observable<RegisterTFState>
    
    let emailText: AnyObserver<String>
    let passwordText: AnyObserver<String>
    let confirmPasswordText: AnyObserver<String>
    
    let didTapNavigationBackButtom: AnyObserver<Void>
    let didTapRegisterButton: AnyObserver<Void>
    let didReturnTFValidation: AnyObserver<Void>
    
    let myDisposeBag = DisposeBag()
    let tfReturn: Observable<Void>
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
        
        let _tfState = PublishSubject<RegisterTFState>()
        tfState = _tfState.asObserver()
        
        let _didReturnTFValidation = PublishSubject<Void>()
        didReturnTFValidation = _didReturnTFValidation.asObserver()
        
        tfReturn = _didTapRegisterButton
            .withLatestFrom(Observable.combineLatest(_emailText, _passwordText, _confirmPasswordText))
            .map({ (mail, pass, cpass) in
                if mail == "" {
                    _tfState.onNext(.isEmptyF)
                } else if pass == "" {
                    _tfState.onNext(.isEmptyS)
                } else if cpass == "" {
                    _tfState.onNext(.isEmptyT)
                } else if mail.isValidEmail() == false {
                    _tfState.onNext(.emailInvalid)
                } else if pass != cpass {
                    _tfState.onNext(.passwordDoesntMatch)
                } else if pass.count < 6 {
                    _tfState.onNext(.passwordLessThanSixCharacters)
                } else {
                    _tfState.onNext(.success)
                }
            }).share()
        
        register = _didReturnTFValidation
            .withLatestFrom(Observable.combineLatest(_emailText, _passwordText, _confirmPasswordText))
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
