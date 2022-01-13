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
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        baseView.addGradient(firstColor: RFKolors.primaryBlue, secondColor: RFKolors.secondaryBlue)
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
                baseView?.emailTextField.placeholderColor = RFKolors.whiteTexts
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.passwordTextFieldPlaceholder
            .subscribe(onNext: { [weak baseView] a in
            
                baseView?.passwordTextField.placeholder = a
                baseView?.passwordTextField.placeholderColor = RFKolors.whiteTexts
                
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
        
        viewModel.login
            .subscribe()
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.state
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case let .error(error):
                    print("DEBUG: Error")
                    self.baseView.activityIndicator.textLabel.rx.text.onNext(error)
                    self.baseView.activityIndicator.indicatorView = JGProgressHUDErrorIndicatorView.init()
                    self.baseView.activityIndicator.dismiss(afterDelay: 2.0)
                case .loading:
                    self.baseView.emailTextField.resignFirstResponder()
                    self.baseView.passwordTextField.resignFirstResponder()
                    self.baseView.activityIndicator.textLabel.rx.text.onNext("Loading")
                    self.baseView.activityIndicator.show(in: self.baseView)
                    print("DEBUG: Load")
                case .success:
                    self.baseView.activityIndicator.isHidden = true
                    self.viewModel.didGoToLoginButton.onNext(())
                    print("DEBUG: Success")
                case .initial:
                    self.baseView.activityIndicator.isHidden = true
                    self.baseView.contentView.isHidden = false
                }
                
            })
            .disposed(by: viewModel.myDisposeBag)
            
    }
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        viewModel.activeTextField?.resignFirstResponder()
//    }

}
