//
//  TimeDataRegisterViewController.swift
//  OClock
//
//  Created by Rafael Hartmann on 08/01/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

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
//        baseView.initialHourPickerView.rx.setDelegate(self).disposed(by: viewModel.disposeBag)
//        baseView.totalPausePickerView.rx.setDelegate(self).disposed(by: viewModel.disposeBag)
//        baseView.totalHoursPickerView.rx.setDelegate(self).disposed(by: viewModel.disposeBag)
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
        
//        baseView.totalHoursTF
//            .rx
//            .text
//            .map { $0 ?? "" }
//            .bind(to: viewModel.totalHoursTFValue)
//            .disposed(by: viewModel.disposeBag)
//
//        baseView.totalPauseHoursTF
//            .rx
//            .text
//            .map { $0 ?? "" }
//            .bind(to: viewModel.pauseHoursTFValue)
//            .disposed(by: viewModel.disposeBag)
//
//        baseView.initialHour
//            .rx
//            .text
//            .map { $0 ?? "" }
//            .bind(to: viewModel.initialHoursTFValue)
//            .disposed(by: viewModel.disposeBag)
        
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
            .subscribe(onNext: { [weak self] a in
                UIView.animate(withDuration: 0.3) {
                    self?.baseView.totalPauseHoursView.isHidden = !a
                    self?.baseView.totalPauseHoursView.alpha = !a ? 0 : 1
                }
                self?.viewModel.pauseSwitchValue.onNext(a)
            })
            .disposed(by: viewModel.disposeBag)
        
        viewModel.initialHoursPickerValue
            .map { [$0.hours, $0.minute] }
            .bind(to: baseView.initialHourPickerView.rx.items(adapter: viewModel.initPickerAdapter))
            .disposed(by: viewModel.disposeBag)
        
        baseView.initialHourPickerView
            .rx
            .itemSelected
            .bind(to: viewModel.selectedInit)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.initText
            .subscribe(onNext: { text in
                self.baseView.initialHour.text = text
                self.baseView.initialHour.test()
            })
            .disposed(by: viewModel.disposeBag)
        
        
        viewModel.totalPauseHoursPickerValue
            .map { [$0.hours, $0.minute] }
            .bind(to: baseView.totalPausePickerView.rx.items(adapter: viewModel.pausePickerAdapter))
            .disposed(by: viewModel.disposeBag)
        
        baseView.totalPausePickerView
            .rx
            .itemSelected
            .bind(to: viewModel.selectedPause)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.pauseText
            .subscribe(onNext: { text in
                self.baseView.totalPauseHoursTF.text = text
                self.baseView.totalPauseHoursTF.test()
            })
            .disposed(by: viewModel.disposeBag)
        
        viewModel.totalHoursPickerValue
            .map { [$0.hours, $0.minute] }
            .bind(to: baseView.totalHoursPickerView.rx.items(adapter: viewModel.totalPickerAdapter))
            .disposed(by: viewModel.disposeBag)
        
        baseView.totalHoursPickerView
            .rx
            .itemSelected
            .bind(to: viewModel.selectedTotal)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.totalText
            .subscribe(onNext: { text in
                self.baseView.totalHoursTF.text = text
                self.baseView.totalHoursTF.test()
            })
            .disposed(by: viewModel.disposeBag)
            
        viewModel.returnedValue
            .subscribe()
            .disposed(by: viewModel.disposeBag)
        
        viewModel.notTrigger
            .subscribe(onNext: {  initialHrs in
                NotificationsCentral.initialHourNotification(initHours: initialHrs)
                self.viewModel.didReturnHome.onNext(())
            })
            .disposed(by: viewModel.disposeBag)
        
        viewModel.state
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading:
                    self.baseView.scrollView.isHidden = true
                    self.baseView.activityIndicator.isHidden = false
                    self.baseView.activityIndicator.activityIndicator.startAnimating()
                case let .error(error):
                    print("error")
                case .success:
                    self.baseView.scrollView.isHidden = false
                    self.baseView.activityIndicator.activityIndicator.stopAnimating()
                    self.baseView.activityIndicator.isHidden = true
                }
            })
            .disposed(by: viewModel.disposeBag)
    }
}

extension TimeDataRegisterViewController: UIPickerViewDelegate {
  
}
