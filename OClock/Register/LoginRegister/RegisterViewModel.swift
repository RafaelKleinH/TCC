//
//  RegisterViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 17/11/21.
//

import Foundation
import RxSwift
import UIKit

protocol RegisterViewModelProtocol {
    typealias Target = RegisterViewCoordinator.Target

    var imageExplicationLabelText: Observable<String> { get }
    var emailTextFieldPlaceholder: Observable<String> { get }
    var passwordTextFieldPlaceholder: Observable<String> { get }
    var confirmPasswordTextFieldPlaceholder: Observable<String> { get }
    var registerButtonTitle: Observable<String> { get }
    
    var userImageInput: AnyObserver<UIImage> { get }
    
    var emailText: AnyObserver<String>  { get }
    var passwordText: AnyObserver<String>  { get }
    var confirmPasswordText: AnyObserver<String> { get }
    
    var navigationTarget: Observable<Target> { get }
    var didTapNavigationBackButtom: AnyObserver<Void> { get }
    var didTapRegisterButton: AnyObserver<Void> { get }
    var didGoToNextView: AnyObserver<Void> { get }
    
    var userImageOutput: Observable<UIImage> { get }
    var myDisposeBag: DisposeBag { get }
    
    var register: Observable<Bool> { get }
}

class RegisterViewModel: RegisterViewModelProtocol {
    
    let imageExplicationLabelText: Observable<String> = .just("Clique no ícone para trocar de imagem")
    let emailTextFieldPlaceholder: Observable<String> = .just("Email")
    let passwordTextFieldPlaceholder: Observable<String> = .just("Password")
    let confirmPasswordTextFieldPlaceholder: Observable<String> = .just("Confirm Password")
    let registerButtonTitle: Observable<String> = .just("Registrar")
    
    let userImageInput: AnyObserver<UIImage>
    
    let navigationTarget: Observable<Target>
    let userImageOutput: Observable<UIImage>
    
    let emailText: AnyObserver<String>
    let passwordText: AnyObserver<String>
    let confirmPasswordText: AnyObserver<String>
    
    
    let didTapNavigationBackButtom: AnyObserver<Void>
    let didTapRegisterButton: AnyObserver<Void>
    let didGoToNextView: AnyObserver<Void>
    
    let myDisposeBag = DisposeBag()
    
    let register: Observable<Bool>
    
    init(service: RegisterViewServiceProtocol = RegisterViewService()) {
        
        let _didTapNavigationBackButtom = PublishSubject<Void>()
        didTapNavigationBackButtom = _didTapNavigationBackButtom.asObserver()
        
        let _didTapRegisterButton = PublishSubject<Void>()
        didTapRegisterButton = _didTapRegisterButton.asObserver()
        
        let _didGoToNextView = PublishSubject<Void>()
        didGoToNextView = _didGoToNextView.asObserver()
        
        let _userImage = PublishSubject<UIImage>()
        userImageInput = _userImage.asObserver()
        
        let _emailText = PublishSubject<String>()
        emailText = _emailText.asObserver()
        
        let _passwordText = PublishSubject<String>()
        passwordText = _passwordText.asObserver()
        
        let _confirmPasswordText = PublishSubject<String>()
        confirmPasswordText = _confirmPasswordText.asObserver()
        
        userImageOutput = _userImage.map { $0 }
        
        register = _didTapRegisterButton
            .withLatestFrom(Observable.combineLatest(_emailText, _passwordText, _confirmPasswordText))
            .filter({ _, password, confirmPassword in
                 password == confirmPassword
            })
            .flatMapLatest { email, password, _ in
                service.registerUser(email: email, password: password)
                    .asObservable()
                    .observe(on: MainScheduler.instance)
                    .do(onNext: { _ in  _didGoToNextView.onNext(()) },
                        onSubscribe: { })
                    .catchError { _ in
                        return Observable.empty()
                    }
            }.share()
            
        
        navigationTarget = Observable.merge(
            _didTapNavigationBackButtom.map { .pop },
            _didGoToNextView.map { .secondRegister }
        )
    }
}
