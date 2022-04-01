//
//  InitViewModel.swift
//  O`Clock
//
//  Created by Rafael Hartmann on 10/11/21.
//

import Foundation
import RxSwift
import FirebaseAuth


enum LoginViewState {
    case initial
    case loading
    case success
    case error(_ error: String)
}

enum LoginTFState {
    case isEmptyF
    case isEmptyS
    case passwordLessThanSixCaracters
    case emailInvalid
    case success
}

protocol LoginViewModelProtocol {
    typealias Target = LoginViewCoordinator.Target
    
    var emailTextFieldPlaceholder: Observable<String> { get }
    var passwordTextFieldPlaceholder: Observable<String> { get }
    
    var loginDefaults: Observable<String> { get }
    
    var state: Observable<LoginViewState> { get }
    var tfState: Observable<LoginTFState> { get }
    
    var navigationTarget: Observable<Target> { get }
    var defaultReturn: Observable<PersonalModel> { get }
    
    var didTapResetPassword: AnyObserver<Void> { get }
    var didTapLoginButton: AnyObserver<Void> { get }
    var didTapRegisterButton: AnyObserver<Void> { get }
    var didGoToLoginButton: AnyObserver<Void> { get }
    
    var toggleDefault: AnyObserver<Bool> { get }
    
    var getUserDefaults: AnyObserver<Void> { get }
    
    var myDisposeBag: DisposeBag { get }
    
    var loginButtonText: BehaviorSubject<String> { get }
    var registerButtonText: Observable<String> { get }
    var loginWithAppleText: Observable<String> { get }
    
    var emailText: AnyObserver<String> { get }
    var passwordText: AnyObserver<String> { get }

    var login: Observable<(AuthDataResult?)>  { get }
    
    var returnTfValidation: Observable<Void> { get }
    
    var didReturnTFValidation: AnyObserver<Void> { get }

}

class LoginViewModel: LoginViewModelProtocol {
    let loginButtonText = BehaviorSubject<String>(value: "LoginButton".localized())
    let registerButtonText: Observable<String>
    let loginWithAppleText: Observable<String>
    let loginDefaults: Observable<String>
    let emailTextFieldPlaceholder: Observable<String>
    let passwordTextFieldPlaceholder: Observable<String>
    let defaultReturn: Observable<PersonalModel>
    
    let toggleDefault: AnyObserver<Bool>
    
    let state: Observable<LoginViewState>
    let tfState: Observable<LoginTFState>
    
    let myDisposeBag = DisposeBag()
    
    let navigationTarget: Observable<Target>
    
    let didTapResetPassword: AnyObserver<Void>
    let didTapLoginButton: AnyObserver<Void>
    let didTapRegisterButton: AnyObserver<Void>
    let didGoToLoginButton: AnyObserver<Void>
    let emailText: AnyObserver<String>
    let passwordText: AnyObserver<String>
    let getUserDefaults: AnyObserver<Void>
    
    let returnTfValidation: Observable<Void>
    
    let didReturnTFValidation: AnyObserver<Void>
    
    let login: Observable<(AuthDataResult?)>
    
    init(service: LoginViewServiceProtocol = LoginViewService()) {
        
        emailTextFieldPlaceholder = .just("LoginEmailTF".localized())
        passwordTextFieldPlaceholder = .just("LoginPasswordTF".localized())
        loginWithAppleText = .just("Resetar senha")
        loginDefaults = .just("LoginUserDefaults".localized())
        registerButtonText = .just("LoginDontHaveAccount".localized())
        
        let _didTapResetPassword = PublishSubject<Void>()
        didTapResetPassword = _didTapResetPassword.asObserver()
        
        let _didTapLoginButton = PublishSubject<Void>()
        didTapLoginButton = _didTapLoginButton.asObserver()
        
        let _didTapRegisterButton = PublishSubject<Void>()
        didTapRegisterButton = _didTapRegisterButton.asObserver()
        
        let _didGoToLoginButton = PublishSubject<Void>()
        didGoToLoginButton = _didGoToLoginButton.asObserver()

        let _emailText = PublishSubject<String>()
        emailText = _emailText.asObserver()
        
        let _passwordText = PublishSubject<String>()
        passwordText = _passwordText.asObserver()
        
        let _state = PublishSubject<LoginViewState>()
        state = _state.asObserver()
        
        let _tfState = PublishSubject<LoginTFState>()
        tfState = _tfState.asObserver()
        
        let _toggleDefault = PublishSubject<Bool>()
        toggleDefault = _toggleDefault.asObserver()
        
        let _getUserDefaults = PublishSubject<Void>()
        getUserDefaults = _getUserDefaults.asObserver()
        
        let _didReturnTFValidation = PublishSubject<Void>()
        didReturnTFValidation = _didReturnTFValidation.asObserver()
        
        
        
        _state.onNext(.initial)
        
        returnTfValidation = _didTapLoginButton.withLatestFrom(Observable.combineLatest(_emailText.asObservable().startWith(""), _passwordText.asObservable().startWith("")))
            .map({ (email, password) in
                if email == "" {
                    _tfState.onNext(.isEmptyF)
                } else if password == "" {
                    _tfState.onNext(.isEmptyS)
                } else if email.isValidEmail() == false {
                    _tfState.onNext(.emailInvalid)
                } else if password.count < 6 {
                    _tfState.onNext(.passwordLessThanSixCaracters)
                } else {
                    _tfState.onNext(.success)
                }
            })
        
        login = _didReturnTFValidation
            .withLatestFrom(Observable.combineLatest(_emailText, _passwordText, _toggleDefault.startWith(false)))
            .flatMapLatest { email, password, toggle in
                service.LoginUser(email: email, password: password, saveUser: toggle)
                    .asObservable()
                    .observe(on: MainScheduler.instance)
                    .do(onNext: { _ in
                        _state.onNext(.success)
                    },
                        onSubscribe: { _state.onNext(.loading) })
                    .catchError { error in
                        _state.onNext(.error(error.localizedDescription))
                        return Observable.empty()
                    }
            }
            .share()
    
        defaultReturn = _getUserDefaults
            .flatMapLatest { _ in
                service.getUserDefaults()
                    .asObservable()
            }
            .share()
        
        navigationTarget = Observable.merge(
            _didTapRegisterButton.map { .registerButton },
            _didGoToLoginButton.map { .loginButton },
            _didTapResetPassword.map { .resetPassword }
        )
    }
}
