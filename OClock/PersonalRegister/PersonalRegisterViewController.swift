
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
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else { return nil }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            baseView.imagePicker.sourceType = type
            self.present(baseView.imagePicker, animated: true)
            
        }
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
        
//        viewModel.imageExplicationLabelText
//            .bind(to: baseView.imageExplicationLabel.rx.text)
//            .disposed(by: viewModel.myDisposeBag)
        
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

