//
//  InitViewModel.swift
//  O`Clock
//
//  Created by Rafael Hartmann on 10/11/21.
//

import Foundation
import RxSwift

enum LoginViewState {
    case initial
    case loading
    case success
    case error
}

protocol LoginViewModelProtocol {
    typealias Target = LoginViewCoordinator.Target
    
    var emailTextFieldPlaceholder: Observable<String> { get }
    var passwordTextFieldPlaceholder: Observable<String> { get }
    
    var activeTextField: UITextField? { get }
    //var state: Observable<LoginViewState> { get }
    var navigationTarget: Observable<Target> { get }
    var didTapLoginButton: AnyObserver<Void> { get }
    var didTapRegisterButton: AnyObserver<Void> { get }
    var keyboardSize: CGFloat { get }
}

class LoginViewModel: LoginViewModelProtocol {
    
    let loginButtonText = BehaviorSubject<String>(value: "LOGIN")
    let registerButtonText: Observable<String>
    let emailTextFieldPlaceholder: Observable<String>
    let passwordTextFieldPlaceholder: Observable<String>
    
   
    
    var activeTextField: UITextField? = nil
    
    let myDisposeBag = DisposeBag()
    
    var navigationTarget: Observable<Target>
    var didTapLoginButton: AnyObserver<Void>
    var didTapRegisterButton: AnyObserver<Void>
    var keyboardSize: CGFloat = 0.0
    
    let emailText: AnyObserver<String>
    let passwordText: AnyObserver<String>
    
    let login: Observable<Bool>
    
    init(service: LoginViewServiceProtocol = LoginViewService()) {
        
        emailTextFieldPlaceholder = .just("EMAIL")
        passwordTextFieldPlaceholder = .just("PASSWORD")
       
        
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.8), .font: RFontsK.QuicksandRegular]
        let attsTitle = NSMutableAttributedString(string: "Don`t have an account?", attributes: atts)
        
        let boldAtts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.8), .font: RFontsK.QuicksandBold]
        let boldedTitle: String? = attsTitle.append(NSAttributedString(string: " SignUp", attributes: boldAtts)) as? String
        
        registerButtonText = .just(boldedTitle ?? "")
        
        let _didTapLoginButton = PublishSubject<Void>()
        didTapLoginButton = _didTapLoginButton.asObserver()
        
        let _didTapRegisterButton = PublishSubject<Void>()
        didTapRegisterButton = _didTapRegisterButton.asObserver()
        
        let _emailText = PublishSubject<String>()
        emailText = _emailText.asObserver()
        
        let _passwordText = PublishSubject<String>()
        passwordText = _passwordText.asObserver()
        
        login = _didTapLoginButton
            .withLatestFrom(Observable.combineLatest(_emailText, _passwordText))
            .flatMapLatest { email, password in
                service.LoginUser(email: email, password: password)
                    .asObservable()
                    .observe(on: MainScheduler.instance)
                    .do(onNext: { ahh in print("valuee: \(ahh)") },
                        onSubscribe: { })
                    .catchError { erro in
                        return Observable.empty()
                    }
            }
            .share()
        
        navigationTarget = Observable.merge(
            _didTapRegisterButton.map { .registerButton },
            _didTapLoginButton.map { .loginButton }
        )
    }
}
