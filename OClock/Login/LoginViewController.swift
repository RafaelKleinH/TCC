//
//  InitViewController.swift
//  O`Clock
//
//  Created by Rafael Hartmann on 10/11/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxKeyboard
import JGProgressHUD

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var baseView: LoginView
    var viewModel: LoginViewModelProtocol
    
    init(baseView: LoginView, viewModel: LoginViewModel) {
        self.baseView = baseView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view = baseView
        baseView.emailTextField.delegate = self
        baseView.passwordTextField.delegate = self
        navigationBarConfig()
        reactiveBinds()
        isUserLogged()
        super.viewDidLoad()
        NotificationsCentral.requestAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBarConfig()
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        baseView.addGradient(firstColor: RFKolors.primaryBlue, secondColor: RFKolors.secondaryBlue)
        baseView.layoutIfNeeded()
    }
    
    func navigationBarConfig() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func reactiveBinds(){
        
//        baseView.emailTextField.rx
//            .controlEvent(.editingDidBegin)
//            .subscribe(onNext: { [weak self] in
//                self?.viewModel.activeTextField = self?.baseView.emailTextField
//            })
//            .disposed(by: viewModel.myDisposeBag)

        
        viewModel.emailTextFieldPlaceholder
            .subscribe(onNext: { [weak baseView] a in
            
                baseView?.emailTextField.placeholder = a
                baseView?.emailTextField.placeholderColor = RFKolors.whiteTexts.withAlphaComponent(0.6)
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.passwordTextFieldPlaceholder
            .subscribe(onNext: { [weak baseView] a in
            
                baseView?.passwordTextField.placeholder = a
                baseView?.passwordTextField.placeholderColor = RFKolors.whiteTexts.withAlphaComponent(0.6)
                
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.loginWithAppleText
            .bind(to: baseView.appleLogin.rx.title())
            .disposed(by: viewModel.myDisposeBag)
        

        viewModel.loginButtonText
            .bind(to: baseView.loginButton.rx.title())
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.registerButtonText
            .bind(to: baseView.registerButton.rx.title())
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.passwordTextField.trailingImageView.rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.baseView.passwordTextField.togglePasswordVisibility()
                self?.baseView.passwordTextField.isSecureTextEntry == true ?
                    self?.baseView.passwordTextField.trailingImageView.setImage(UIImage(named: CustomImages.securityEnterDisabled), for: .normal)
                    :
                    self?.baseView.passwordTextField.trailingImageView.setImage(UIImage(named: CustomImages.securityEnterEnabled), for: .normal)
            })
            .disposed(by: viewModel.myDisposeBag)
        
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] kh in
                guard let self = self else { return }
                //self.baseView.scrollView.bottomAnchor.constraint(equalTo: self.baseView.bottomAnchor).constant = kh
                self.baseView.layoutIfNeeded()
                self.baseView.updateConstraints()
            })
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.appleLogin.rx.tap
            .bind(to: viewModel.didTapResetPassword)
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.loginButton.rx.tap
            .bind(to: viewModel.didTapLoginButton)
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.registerButton.rx.tap
            .bind(to: viewModel.didTapRegisterButton)
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.emailTextField.rx.text
            .map { $0 ?? "" }
            .bind(to: viewModel.emailText)
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.passwordTextField.rx.text
            .map { $0 ?? "" }
            .bind(to: viewModel.passwordText)
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.userDefaultSwith.rx
            .value
            .map { $0 }
            .bind(to: viewModel.toggleDefault)
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.loginDefaults
            .bind(to: baseView.userDefaultLabel.rx.text)
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.login
            .subscribe()
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.defaultReturn
            .throttle(.microseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] user in
                self?.viewModel.emailText.onNext(user.mail)
                self?.viewModel.passwordText.onNext(user.password)
                self?.viewModel.toggleDefault.onNext(false)
                self?.viewModel.didTapLoginButton.onNext(())
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.returnTfValidation
            .subscribe()
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.state
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .error:
                    self.baseView.activityIndicator.activityIndicator.stopAnimating()
                    self.baseView.activityIndicator.isHidden = true
                    self.baseView.returnAlert(isSuccess: false, vc: self)
                    self.baseView.contentView.isHidden = false
                case .loading:
                    self.baseView.contentView.isHidden = true
                    self.baseView.activityIndicator.isHidden = false
                    self.baseView.activityIndicator.activityIndicator.startAnimating()
                case .success:
                    self.baseView.activityIndicator.activityIndicator.stopAnimating()
                    self.baseView.activityIndicator.isHidden = true
                    self.baseView.contentView.isHidden = false
                    self.viewModel.didGoToLoginButton.onNext(())
                case .initial:
                    self.baseView.activityIndicator.isHidden = true
                    self.baseView.contentView.isHidden = false
                }
            })
            .disposed(by: viewModel.myDisposeBag)
        
 
        viewModel.tfState
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .isEmptyF:
                    self.baseView.emailTextField.setErrorView(withError: "LoginTFisEmpty".localized())
                    self.baseView.passwordTextField.setRemoveError()
                case .isEmptyS:
                    self.baseView.emailTextField.setRemoveError()
                    self.baseView.passwordTextField.setErrorView(withError: "LoginTFisEmpty".localized())
                case .emailInvalid:
                    self.baseView.emailTextField.setErrorView(withError: "LoginTFEmailInvalid".localized())
                    self.baseView.passwordTextField.setRemoveError()
                case .passwordLessThanSixCaracters:
                    self.baseView.emailTextField.setRemoveError()
                    self.baseView.passwordTextField.setErrorView(withError: "LoginTFPassLessThanSixCharacters".localized())
                case .success:
                    self.baseView.emailTextField.setRemoveError()
                    self.baseView.passwordTextField.setRemoveError()
                    self.viewModel.didReturnTFValidation.onNext(())
                }
            })
            .disposed(by: viewModel.myDisposeBag)
    }
    
    func isUserLogged() {
        let isUserLogged = UserDefaults.standard.bool(forKey: UserDefaultValue.logged.rawValue)
        
        if isUserLogged {
            viewModel.getUserDefaults.onNext(())
        }
    }


}
