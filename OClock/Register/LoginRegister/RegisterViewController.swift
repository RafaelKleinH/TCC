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
        baseView.imagePicker.delegate = self
        baseView.emailTextField.delegate = self
        baseView.passwordTextField.delegate = self
        baseView.confirmPasswordTextField.delegate = self
        navigationBarConfig()
        rxBindings()
        

    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        baseView.addGradient(firstColor: UIColor(red: 0/255, green: 78/255, blue: 146/255, alpha: 1), secondColor: UIColor(red: 0/255, green: 4/255, blue: 40/255, alpha: 1))
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func navigationBarConfig() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent =  true
        
        navigationController?.navigationItem.leftBarButtonItem?.rx.tap
            .bind(to: viewModel.didTapNavigationBackButtom)
            .disposed(by: viewModel.myDisposeBag)
    }
    
    private func rxBindings() {
    
        baseView.imageView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.present(self.baseView.imagePicker, animated: true, completion: nil)
            })
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
        
        
        viewModel.userImageOutput
            .bind(to: baseView.imageView.rx.image)
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.imageExplicationLabelText
            .bind(to: baseView.imageExplicationLabel.rx.text)
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
            .subscribe(onNext: {  ahh in
                if ahh {
                    
                }
            })
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.registerButton.rx.tap
            .bind(to: viewModel.didTapRegisterButton)
            .disposed(by: viewModel.myDisposeBag)
            
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else { return nil }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            baseView.imagePicker.sourceType = type
            self.present(baseView.imagePicker, animated: true)
            
        }
    }
    
    private func present(from sourceView: UIView) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        self.present(alertController, animated: true)
    }
    
    private func keyboardWillHide(notification: Notification) {
        self.baseView.scrollView.frame.origin.y = 0
    }
    
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.editedImage] as? UIImage {
            viewModel.userImageInput.onNext(img)
            dismiss(animated: true, completion: nil)
        } else if let img = info[.originalImage] as? UIImage {
            viewModel.userImageInput.onNext(img)
            dismiss(animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension RegisterViewController: UITextFieldDelegate {}
