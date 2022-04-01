//
//  File.swift
//  OClock
//
//  Created by Rafael Hartmann on 25/03/22.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class ResetViewController: UIViewController {
    
    var baseView: ResetView
    var viewModel: ResetViewModelProtocol
    
    init(vm: ResetViewModelProtocol, v: ResetView) {
        baseView = v
        viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rxBinds()
        view = baseView
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
    
    func rxBinds() {
        
        baseView.emailTextField
            .rx
            .text
            .map { $0 ?? "" }
            .bind(to: viewModel.emailText)
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.confirmEmailTextField
            .rx
            .text
            .map { $0 ?? "" }
            .bind(to: viewModel.confirmEmailText)
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.registerButton
            .rx
            .tap
            .bind(to: viewModel.didTapBottomButton)
            .disposed(by: viewModel.myDisposeBag)
        
        
        viewModel.buttonReturn
            .subscribe()
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.state
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading:
                    self.baseView.contentView.isHidden = true
                    self.baseView.activityIndicator.isHidden = false
                    self.baseView.activityIndicator.activityIndicator.startAnimating()
                case .error:
                    self.baseView.contentView.isHidden = false
                    self.baseView.activityIndicator.activityIndicator.stopAnimating()
                    self.baseView.activityIndicator.isHidden = true
                    self.baseView.returnAlert(isSuccess: false, vc: self)
                case .success:
                    self.baseView.contentView.isHidden = false
                    self.baseView.activityIndicator.isHidden = true
                    self.baseView.activityIndicator.activityIndicator.stopAnimating()
                    self.baseView.returnAlert(isSuccess: true, vc: self)
                }
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.bottomButtonText
            .bind(to: baseView.registerButton.rx.title())
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.emailBindText
            .subscribe(onNext: { [weak baseView] text in
                baseView?.emailTextField.placeholder = text
                baseView?.emailTextField.placeholderColor = RFKolors.whiteTexts.withAlphaComponent(0.6)
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.confirmEmailBindText
            .subscribe(onNext: { [weak baseView] text in
                baseView?.confirmEmailTextField.placeholder = text
                baseView?.confirmEmailTextField.placeholderColor = RFKolors.whiteTexts.withAlphaComponent(0.6)
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.tfState
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .isntEqual:
                    self.baseView.emailTextField.setErrorView(withError: "errorTFisntEqual".localized())
                    self.baseView.confirmEmailTextField.setErrorView(withError: "errorTFisntEqual".localized())
                case .isntMail:
                    self.baseView.emailTextField.setErrorView(withError: "errorTFisntMail".localized())
                case .isEmptyF:
                    self.baseView.confirmEmailTextField.setRemoveError()
                    self.baseView.emailTextField.setErrorView(withError: "errorTFisEmpty".localized())
                case .isEmptyS:
                    self.baseView.emailTextField.setRemoveError()
                    self.baseView.confirmEmailTextField.setErrorView(withError: "errorTFisEmpty".localized())
                case .success:
                    self.baseView.emailTextField.setRemoveError()
                    self.baseView.confirmEmailTextField.setRemoveError()
                    self.viewModel.didSuccessTFValidations.onNext(())
                }
                
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.returnTF
            .subscribe()
            .disposed(by: viewModel.myDisposeBag)
    }
}
