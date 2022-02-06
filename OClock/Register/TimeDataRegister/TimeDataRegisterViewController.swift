//
//  TimeDataRegisterViewController.swift
//  OClock
//
//  Created by Rafael Hartmann on 08/01/22.
//

import Foundation
import UIKit

class TimeDataRegisterViewController: UIViewController {
    
    var viewModel: TimeDataRegisterViewModelProtocol
    var baseView: TimeDataRegisterView
    
    init(vm: TimeDataRegisterViewModelProtocol, bv: TimeDataRegisterView) {
        viewModel = vm
        baseView = bv
        super.init(nibName: nil, bundle: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        baseView.addGradient(firstColor: RFKolors.primaryBlue, secondColor: RFKolors.secondaryBlue)
        rxBinds()
    }
    
    override func viewDidLoad() {
        view = baseView
        setupNavBar()
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillDisappear(animated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        title = viewModel.navBarTitle
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: RFKolors.whiteTexts.withAlphaComponent(1), NSAttributedString.Key.font: UIFont(name: RFontsK.QuicksandBold, size: 24) ?? UIFont.systemFont(ofSize: 24)]
    }
    
    private func rxBinds() {
        
        baseView.totalHoursTF
            .rx
            .text
            .map { $0 ?? "" }
            .bind(to: viewModel.totalHoursTFValue)
            .disposed(by: viewModel.disposeBag)
        
        baseView.totalPauseHoursTF
            .rx
            .text
            .map { $0 ?? "" }
            .bind(to: viewModel.pauseHoursTFValue)
            .disposed(by: viewModel.disposeBag)
        
        baseView.initialHour
            .rx
            .text
            .map { $0 ?? "" }
            .bind(to: viewModel.initialHoursTFValue)
            .disposed(by: viewModel.disposeBag)
        
        baseView.confirmButton
            .rx
            .tap
            .bind(to: viewModel.didTapBottomButton)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.buttonTitle
            .bind(to: baseView.confirmButton.rx.title())
            .disposed(by: viewModel.disposeBag)
        
        viewModel.totalHoursTextPH
            .bind(to: baseView.totalHoursTF.rx.placeholder)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.pauseLabelTextPH
            .bind(to: baseView.pauseLabel.rx.text)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.totalPauseHoursTextPH
            .bind(to: baseView.totalPauseHoursTF.rx.placeholder)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.initialHoursPH
            .bind(to: baseView.initialHour.rx.placeholder)
            .disposed(by: viewModel.disposeBag)
        
        baseView.setupViewBasics()
        
        baseView.pauseSwith
            .rx
            .value
            .bind(to: viewModel.pauseSwitchValue)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.subPauseSwitchValue
            .subscribe(onNext: { [weak self] a in
                UIView.animate(withDuration: 0.3) {
                    self?.baseView.totalPauseHoursView.isHidden = !a
                    self?.baseView.totalPauseHoursView.alpha = !a ? 0 : 1
                }
            })
            .disposed(by: viewModel.disposeBag)
            
        viewModel.returnedValue
            .subscribe(onNext: { bool in
                print(bool)
            })
            .disposed(by: viewModel.disposeBag)
        
    }
}
