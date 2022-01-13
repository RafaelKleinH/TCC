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

protocol LoginViewModelProtocol {
    typealias Target = LoginViewCoordinator.Target
    
    var emailTextFieldPlaceholder: Observable<String> { get }
    var passwordTextFieldPlaceholder: Observable<String> { get }
    
    var state: Observable<LoginViewState> { get }
    var navigationTarget: Observable<Target> { get }
    var didTapLoginButton: AnyObserver<Void> { get }
    var didTapRegisterButton: AnyObserver<Void> { get }
    var didGoToLoginButton: AnyObserver<Void> { get }
    
    var myDisposeBag: DisposeBag { get }
    
    var loginButtonText: BehaviorSubject<String> { get }
    var registerButtonText: Observable<String> { get }
    var loginWithAppleText: Observable<String> { get }
    
    var emailText: AnyObserver<String> { get }
    var passwordText: AnyObserver<String> { get }

    var login: Observable<(AuthDataResult?)>  { get }

}

class LoginViewModel: LoginViewModelProtocol {
    
    let loginButtonText = BehaviorSubject<String>(value: "LoginButton".localized())
    let registerButtonText: Observable<String>
    let loginWithAppleText: Observable<String>
    
    let emailTextFieldPlaceholder: Observable<String>
    let passwordTextFieldPlaceholder: Observable<String>
    
    let state: Observable<LoginViewState>
    
    let myDisposeBag = DisposeBag()
    
    let navigationTarget: Observable<Target>
    let didTapLoginButton: AnyObserver<Void>
    let didTapRegisterButton: AnyObserver<Void>
    let didGoToLoginButton: AnyObserver<Void>
    
    let emailText: AnyObserver<String>
    let passwordText: AnyObserver<String>
    
    let login: Observable<(AuthDataResult?)>
    
    
    
    init(service: LoginViewServiceProtocol = LoginViewService()) {
        
        emailTextFieldPlaceholder = .just("LoginEmailTF".localized())
        passwordTextFieldPlaceholder = .just("LoginPasswordTF".localized())
        loginWithAppleText = .just("LoginWithApple".localized())
        
        registerButtonText = .just("LoginDontHaveAccount".localized())
        
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
        state = _state.asObservable()
        
        login = _didTapLoginButton
            .withLatestFrom(Observable.combineLatest(_emailText, _passwordText))
            .flatMapLatest { email, password in
                service.LoginUser(email: email, password: password)
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
        
        navigationTarget = Observable.merge(
            _didTapRegisterButton.map { .registerButton },
            _didGoToLoginButton.map { .loginButton }
        )
    }
}
