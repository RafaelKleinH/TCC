
//
//  PersonalRegisterViewController.swift
//  OClock
//
//  Created by Rafael Hartmann on 08/01/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture

class PersonalRegisterViewController: UIViewController {
    
    var viewModel: PersonalRegisterViewModelProtocol
    var baseView: PersonalRegisterView
    
    
    init(viewModel: PersonalRegisterViewModel, baseView: PersonalRegisterView) {
        self.viewModel = viewModel
        self.baseView = baseView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        baseView.imagePicker.delegate = self
        view = baseView
        rxBinds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navConfig()
        baseView.addGradient(firstColor: RFKolors.primaryBlue, secondColor: RFKolors.secondaryBlue)
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else { return nil }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            baseView.imagePicker.sourceType = type
            self.present(baseView.imagePicker, animated: true)
            
        }
    }
    
    private func navConfig() {
        navigationItem.hidesBackButton = false
        navigationItem.setHidesBackButton(false, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        title = "REGISTRO PESSOAL"
        navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: RFKolors.whiteTexts, NSAttributedString.Key.font: UIFont(name: RFontsK.QuicksandBold, size: 24) ?? UIFont.systemFont(ofSize: 24)]
    }
    
    private func rxBinds() {
        baseView.imageView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.present(self.baseView.imagePicker, animated: true, completion: nil)
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.userImageOutput
            .bind(to: baseView.imageView.rx.image)
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.explicationLabelTitle
            .subscribe(onNext: { [weak baseView] text in
                baseView?.imageExplicationLabel.text = text
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.nameTextFieldPlaceholder
            .subscribe(onNext: { [weak baseView] text in
                baseView?.nameTextField.placeholder = text
                baseView?.nameTextField.placeholderColor = RFKolors.whiteTexts.withAlphaComponent(0.6)
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.occupationTextFieldPlaceholder
            .subscribe(onNext: { [weak baseView] text in
                baseView?.occupationTextField.placeholder = text
                baseView?.occupationTextField.placeholderColor = RFKolors.whiteTexts.withAlphaComponent(0.6)
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.registerButtonTitle
            .subscribe(onNext: { [weak baseView] text in
                baseView?.registerButton.setTitle(text, for: .normal)
            })
            .disposed(by: viewModel.myDisposeBag)
        
        //TODO MEMORY LEAK AQUI
        viewModel.requests
            .subscribe()
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.nameTextField.rx.text
            .map { $0 ?? "" }
            .bind(to: viewModel.nameText)
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.occupationTextField.rx.text
            .map { $0 ?? "" }
            .bind(to: viewModel.occupationText)
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.registerButton.rx.tap
            .bind(to: viewModel.loadData)
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.personalDataObs
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                guard let data = data else { return }
                self?.baseView.nameTextField.rx.text.onNext(data.name)
                self?.baseView.occupationTextField.rx.text.onNext(data.occupation)
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.state
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .initial:
                    print("init")
                case .loading:
                    print("loading")
                case .success:
                    if self.viewModel.isFirstRegister {
                        self.viewModel.didGoToNextView.onNext(())
                    } else {
                        //TODO
                    }
                case let .error(error):
                    print(error)
                }
            })
            
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
    
}

extension PersonalRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

