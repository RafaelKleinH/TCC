//
//  RegisterViewController.swift
//  OClock
//
//  Created by Rafael Hartmann on 17/11/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture
import RxKeyboard

class RegisterViewController: UIViewController {
    
    var viewModel: RegisterViewModelProtocol
    var baseView: RegisterView
    
    init(viewModel: RegisterViewModelProtocol, baseView: RegisterView) {
        self.viewModel = viewModel
        self.baseView = baseView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view = baseView
       
        baseView.emailTextField.delegate = self
        baseView.passwordTextField.delegate = self
        baseView.confirmPasswordTextField.delegate = self
        rxBindings()
        

    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBarConfig()
        baseView.addGradient(firstColor: RFKolors.primaryBlue, secondColor: RFKolors.secondaryBlue)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func navigationBarConfig() {
        tabBarController?.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
        tabBarController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.topItem?.title = "REGISTRO"
        navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: RFKolors.whiteTexts.withAlphaComponent(1), NSAttributedString.Key.font: UIFont(name: RFontsK.QuicksandBold, size: 24) ?? UIFont.systemFont(ofSize: 24)]
        navigationController?.navigationItem.leftBarButtonItem?.rx.tap
            .bind(to: viewModel.didTapNavigationBackButtom)
            .disposed(by: viewModel.myDisposeBag)
    }
    
    private func rxBindings() {
        
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
        
        viewModel.emailTextFieldPlaceholder
            .subscribe(onNext: { [weak baseView] text in
                baseView?.emailTextField.placeholder = text
                baseView?.emailTextField.placeholderColor = RFKolors.whiteTexts
            })
            .disposed(by: viewModel.myDisposeBag)

        viewModel.passwordTextFieldPlaceholder
            .subscribe(onNext: { [weak baseView] text in
                baseView?.passwordTextField.placeholder = text
                baseView?.passwordTextField.placeholderColor = RFKolors.whiteTexts
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.confirmPasswordTextFieldPlaceholder
            .subscribe(onNext: { [weak baseView] text in
                baseView?.confirmPasswordTextField.placeholder = text
                baseView?.confirmPasswordTextField.placeholderColor = RFKolors.whiteTexts
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.registerButtonTitle
            .subscribe(onNext: { [weak baseView] text in
                baseView?.registerButton.setTitle(text, for: .normal)
            })
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.confirmPasswordTextField.trailingImageView.rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.baseView.confirmPasswordTextField.togglePasswordVisibility()
                self?.baseView.confirmPasswordTextField.isSecureTextEntry == true ?
                    self?.baseView.confirmPasswordTextField.trailingImageView.setImage(UIImage(named: CustomImages.securityEnterDisabled), for: .normal)
                    :
                    self?.baseView.confirmPasswordTextField.trailingImageView.setImage(UIImage(named: CustomImages.securityEnterEnabled), for: .normal)
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.state
            .subscribe(onNext: { state in
                switch state {
                    case .data:
                        print("DEBUG: data")
                    case .loading:
                        print("DEBUG: load")
                    case let .error(error):
                        print("DEBUG: \(error)")
                }
                
            })
            .disposed(by: viewModel.myDisposeBag)
        
        
        baseView.emailTextField.rx.text
            .map { $0 ?? "" }
            .bind(to: viewModel.emailText)
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.passwordTextField.rx.text
            .map { $0 ?? "" }
            .bind(to: viewModel.passwordText)
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.confirmPasswordTextField.rx.text
            .map { $0 ?? "" }
            .bind(to: viewModel.confirmPasswordText)
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.register
            .subscribe()
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.registerButton.rx.tap
            .bind(to: viewModel.didTapRegisterButton)
            .disposed(by: viewModel.myDisposeBag)
            
    }
    
//    private func keyboardWillHide(notification: Notification) {
//        self.baseView.scrollView.frame.origin.y = 0
//    }
    
}

extension RegisterViewController: UITextFieldDelegate {}

