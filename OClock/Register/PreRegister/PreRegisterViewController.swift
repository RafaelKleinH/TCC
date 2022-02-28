//
//  PreRegisterViewController.swift
//  OClock
//
//  Created by Rafael Hartmann on 23/02/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PreRegisterViewController: UIViewController {
    
    private var viewModel: PreRegisterViewModelProtocol
    private var baseView: PreRegisterView
    
    init(vm: PreRegisterViewModelProtocol, v: PreRegisterView) {
        viewModel = vm
        baseView = v
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = baseView
        rxSwift()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navConfig()
        baseView.addGradient(firstColor: RFKolors.primaryBlue, secondColor: RFKolors.secondaryBlue)
        
    }
    
    private func navConfig() {
        navigationItem.hidesBackButton = true
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.topItem?.title = "OLÁ, TUDO BEM ?"
        navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: RFKolors.whiteTexts, NSAttributedString.Key.font: UIFont(name: RFontsK.QuicksandBold, size: 24) ?? UIFont.systemFont(ofSize: 24)]
    }
    
    func rxSwift() {
        
        viewModel.textLabelText
            .bind(to: baseView.textLabel.rx.text)
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.confirmButtonText
            .bind(to: baseView.confirmButton.rx.title())
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.confirmButton
            .rx
            .tap
            .bind(to: viewModel.didTapBottomButton)
            .disposed(by: viewModel.myDisposeBag)
    }
}
