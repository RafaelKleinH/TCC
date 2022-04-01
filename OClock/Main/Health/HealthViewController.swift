//
//  HealthViewController.swift
//  OClock
//
//  Created by Rafael Hartmann on 15/03/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture

class HealthViewController: UIViewController {
    
    var baseView: HealthView
    var viewModel: HealthViewModelProtocol
    
    init(v: HealthView, vm: HealthViewModelProtocol) {
        baseView = v
        viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = baseView
        rxBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
        tabBarController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.topItem?.title = "ASSISTENTE DE SAÚDE"
        navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: RFKolors.modeSecondary, NSAttributedString.Key.font: UIFont(name: RFontsK.QuicksandBold, size: 24) ?? UIFont.systemFont(ofSize: 24)]
        super.viewWillAppear(animated)
    }
    
    func rxBind() {
        
        baseView.explicationOpen
            .rx
            .gesture(.tap(configuration: nil))
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.3) {
                    self.baseView.explanationaView.isHidden = !self.viewModel.isOpen
                    self.baseView.explicationLabel.alpha = !self.viewModel.isOpen ? 0 : 1
                    self.viewModel.isOpen.toggle()
                }
            })
            .disposed(by: viewModel.myDisposeBag)
    }
}
