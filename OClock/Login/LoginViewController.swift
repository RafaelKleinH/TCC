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

class LoginViewController: UIViewController {
    
    var baseView: LoginView
    var viewModel: LoginViewModel
    
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
        
        baseView.addGradient(firstColor: UIColor(red: 0/255, green: 78/255, blue: 146/255, alpha: 1), secondColor: UIColor(red: 0/255, green: 4/255, blue: 40/255, alpha: 1))
    }
    
    func navigationBarConfig() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func reactiveBinds(){
        
        baseView.emailTextField.rx
            .controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.activeTextField = self?.baseView.emailTextField
            })
            .disposed(by: viewModel.myDisposeBag)
        
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
            .subscribe(onNext: { _ in
                print("Sobrescreveu")
            })
            .disposed(by: viewModel.myDisposeBag)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewModel.activeTextField?.resignFirstResponder()
    }
}

extension LoginViewController: UITextFieldDelegate {

}
