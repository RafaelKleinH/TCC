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
                baseView?.emailTextField.placeholderColor = RFKolors.whiteTexts.withAlphaComponent(0.6)
            })
            .disposed(by: viewModel.myDisposeBag)

        viewModel.passwordTextFieldPlaceholder
            .subscribe(onNext: { [weak baseView] text in
                baseView?.passwordTextField.placeholder = text
                baseView?.passwordTextField.placeholderColor = RFKolors.whiteTexts.withAlphaComponent(0.6)
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.confirmPasswordTextFieldPlaceholder
            .subscribe(onNext: { [weak baseView] text in
                baseView?.confirmPasswordTextField.placeholder = text
                baseView?.confirmPasswordTextField.placeholderColor = RFKolors.whiteTexts.withAlphaComponent(0.6)
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
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                    case .data:
                        self.baseView.contentView.isHidden = false
                        self.baseView.activityIndicator.isHidden = true
                        self.baseView.activityIndicator.activityIndicator.stopAnimating()
                        self.baseView.returnAlert(isSuccess: true, vc: self)
                    case .loading:
                        self.baseView.contentView.isHidden = true
                        self.baseView.activityIndicator.isHidden = false
                        self.baseView.activityIndicator.activityIndicator.startAnimating()
                    case let .error(error):
                        self.baseView.contentView.isHidden = false
                        self.baseView.activityIndicator.isHidden = true
                        self.baseView.activityIndicator.activityIndicator.stopAnimating()
                        self.baseView.returnAlert(isSuccess: false, vc: self)
                }
                
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.tfReturn
            .subscribe()
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.tfState
            .subscribe(onNext: { [weak self] state in
                switch state {
                case .isEmptyF:
                    self?.baseView.emailTextField.setErrorView(withError: "RegisterTFIsEmpty".localized())
                    self?.baseView.passwordTextField.setRemoveError()
                    self?.baseView.confirmPasswordTextField.setRemoveError()
                case .isEmptyS:
                    self?.baseView.emailTextField.setRemoveError()
                    self?.baseView.passwordTextField.setErrorView(withError: "RegisterTFIsEmpty".localized())
                    self?.baseView.confirmPasswordTextField.setRemoveError()
                case .isEmptyT:
                    self?.baseView.emailTextField.setRemoveError()
                    self?.baseView.confirmPasswordTextField.setErrorView(withError: "RegisterTFIsEmpty".localized())
                    self?.baseView.passwordTextField.setRemoveError()
                case .passwordDoesntMatch:
                    self?.baseView.emailTextField.setRemoveError()
                    self?.baseView.confirmPasswordTextField.setErrorView(withError: "RegisterTFPasswordDoesntMatch".localized())
                    self?.baseView.passwordTextField.setErrorView(withError: "RegisterTFPasswordDoesntMatch".localized())
                case .emailInvalid:
                    self?.baseView.emailTextField.setErrorView(withError: "RegisterTFEmailInvalid".localized())
                    self?.baseView.passwordTextField.setRemoveError()
                    self?.baseView.confirmPasswordTextField.setRemoveError()
                case .passwordLessThanSixCharacters:
                    self?.baseView.emailTextField.setRemoveError()
                    self?.baseView.passwordTextField.setErrorView(withError: "RegisterTFPasswordLessThanSixCharacters".localized())
                    self?.baseView.confirmPasswordTextField.setRemoveError()
                case .success:
                    self?.baseView.emailTextField.setRemoveError()
                    self?.baseView.passwordTextField.setRemoveError()
                    self?.baseView.confirmPasswordTextField.setRemoveError()
                    self?.viewModel.didReturnTFValidation.onNext(())
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
}

extension RegisterViewController: UITextFieldDelegate {}

