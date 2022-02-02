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
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        title = "REGISTRO DE HORAS"
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: RFKolors.whiteTexts.withAlphaComponent(1), NSAttributedString.Key.font: UIFont(name: RFontsK.QuicksandBold, size: 24) ?? UIFont.systemFont(ofSize: 24)]
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillDisappear(animated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rxBinds() {
        
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
        
        baseView.pauseSwith.rx.value
            .bind(to: viewModel.pauseSwitchValue)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.subPauseSwitchValue.subscribe(onNext: { [] a in
             UIView.animate(withDuration: 0.3) {
                self.baseView.totalPauseHoursView.isHidden = !a
                self.baseView.totalPauseHoursView.alpha = !a ? 0 : 1
            }
        })
        .disposed(by: viewModel.disposeBag)
            
    }
}
