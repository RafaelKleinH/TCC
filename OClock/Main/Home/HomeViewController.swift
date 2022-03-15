//
//  HomeViewController.swift
//  OClock
//
//  Created by Rafael Hartmann on 05/01/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture

class HomeViewController: UIViewController {

    var viewModel: HomeViewModelProtocol
    var baseView: HomeView
    
    init(vm: HomeViewModel, v: HomeView) {
        viewModel = vm
        baseView = v
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        self.view = baseView
        rxBinds()
        viewModel.didViewLoad.onNext(())
        viewModel.timerCentral.startTime =  viewModel.timerCentral.userDefaults.object(forKey:  viewModel.timerCentral.START_TIME_KEY) as? Date
        viewModel.timerCentral.stopTime =  viewModel.timerCentral.userDefaults.object(forKey:  viewModel.timerCentral.STOP_TIME_KEY) as? Date
        viewModel.timerCentral.isOpen =  viewModel.timerCentral.userDefaults.bool(forKey:  viewModel.timerCentral.COUNTING_KEY)
       
        if  viewModel.timerCentral.isOpen {
            viewModel.timerCentral.startHelper()
        } else {
            viewModel.timerCentral.stopTimer()
            if let startTime =  viewModel.timerCentral.startTime {
                if let stopTime =  viewModel.timerCentral.stopTime {
                    let time =  viewModel.timerCentral.calcRestartTime(start: startTime, stop: stopTime)
                    let diff = Date().timeIntervalSince(time)
                    viewModel.timerCentral.midTime.onNext(Int(diff))
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func rxBinds() {
        
        viewModel.userData
            .subscribe()
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.hoursData
            .subscribe(onNext: { [weak self] data in
                self?.viewModel.hasBreak = data.hasBreak
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.ableFakedRegister
            .subscribe()
            .disposed(by: viewModel.myDisposeBag)
        
        
        viewModel.usableHoursData
            .subscribe(onNext: { totalBreak, totalHours, hasBreak in
                self.viewModel.timerCentral.totalHours = totalHours
                self.viewModel.timerCentral.hasBreak = hasBreak
                
                self.baseView.circularProgress.startProgress(angle: 290, time: TimeInterval(totalHours))
                self.baseView.circularProgress.pauseProgress()
                if let hasBreak = hasBreak {
                    self.baseView.addSubProgress(hasBreak: hasBreak)
                }
            })
            .disposed(by: viewModel.myDisposeBag)
        
        var mainProgressValue: Double = 0.0
        
        viewModel.timerCentral
            .midTime
            .subscribe(onNext: { [weak self] time in
                guard let self = self, let totalHours = self.viewModel.timerCentral.totalHours else { return }
                let num = Double(time)
                let halfHours = totalHours / 2
                let hasBreak = self.viewModel.hasBreak
                
                if mainProgressValue == 0 {
                    self.baseView.circularProgress.circularProgress.progress = 0.0
                } else if mainProgressValue < 0.81 {
                    let mainProgress = self.viewModel.calculatePercentage(value: num, min: 0.0, max: Double(totalHours))
                    self.baseView.circularProgress.circularProgress.progress = mainProgress / 125
                    mainProgressValue = mainProgress / 125
                } else {
                    self.baseView.circularProgress.circularProgress.progress = 0.81
                }
                    
                if hasBreak == true {
                    let firstSub = self.viewModel.calculatePercentage(value: num, min: 0.0, max: Double(halfHours))
                    UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                        self.baseView.firstSubProgress.progress.circularProgress.progress = firstSub / 100
                    }, completion: nil)
                        
                    let thirdSub = self.viewModel.calculatePercentage(value: num, min: Double(halfHours), max: Double(totalHours))
                    UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                        self.baseView.thirdSubProgress.progress.circularProgress.progress = thirdSub / 100
                    }, completion: nil)
                    
                } else {
                  
                }
                let fourthMax = totalHours + 5
                let fourthSub = self.viewModel.calculatePercentage(value: num, min: Double(totalHours), max: Double(fourthMax))
                UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                    self.baseView.fourthSubProgress.progress.circularProgress.progress = fourthSub / 100
                }, completion: nil)
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.totalBreakHours
            .subscribe()
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.totalHours
            .subscribe()
            .disposed(by: viewModel.myDisposeBag)

        viewModel.buttonBack
            .subscribe(onNext: { hasBrk in
                guard let hasBreak = hasBrk else { return }
                
                if hasBreak {
                    if self.viewModel.timerCentral.isOpen {
                        self.viewModel.timerCentral.pauseTimer()
                       
                     
                        //self.viewModel.saveHours(inOrOut: "Out: ")
                    } else {
                        self.viewModel.timerCentral.startTimer()
                        
                        //self.viewModel.saveHours(inOrOut: "In: ")
                    }
                } else {
                    if self.viewModel.timerCentral.isOpen {
                        self.viewModel.timerCentral.pauseTimer()
                      
                       // self.viewModel.timerCentral.saveHours(inOrOut: "Out: ")
                    } else {
                        self.viewModel.timerCentral.startTimer()
                      
                        //self.viewModel.timerCentral.saveHours(inOrOut: "In: ")
                    }
                }
            })
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.timeButton
            .rx
            .tap
            .bind(to: viewModel.didTapButton)
            .disposed(by: viewModel.myDisposeBag)
        
       // var valsue = 0
        
        baseView.timeButton
            .rx
            .longPressGesture(configuration: .none)
            .skip(1)
            //.throttle(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: {  value in
                if value.state == .began {
                    self.viewModel.didLongPressButton.onNext(())
                }
            })
            .disposed(by: viewModel.myDisposeBag)
        
        
        
        baseView.alert
            .addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
        
        baseView.alert
            .addAction(UIAlertAction(title: "Encerrar", style: .default, handler: { _ in
                self.viewModel.timerCentral.resetAction()
            }))
        
        viewModel.didReturnLongPress
            .subscribe(onNext: {
                self.present(self.baseView.alert, animated: true, completion: nil)
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.stringTime
            .subscribe(onNext: { (text, num) in
                self.baseView.timeLabel.rx.text.onNext(text)
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.userName
            .bind(to: baseView.nameLabel.rx.text)
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.errorView
            .errorButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.didViewLoad.onNext(())
            })
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.personalImageView
            .rx
            .tapGesture()
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.didGoToPersonalRegister.onNext(())
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.state
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .personalLoading:
                    self.baseView.viewState(hstate: .personalLoading)
                case .personalData:
                    self.viewModel.didLoadUserData.onNext(())
                case .personalError:
                    self.baseView.viewState(hstate: .personalError(""))
                case .hoursLoading:
                    self.baseView.viewState(hstate: .hoursLoading)
                case .hoursData:
                    self.baseView.viewState(hstate: .hoursData)
                    self.baseView.scrollView.isHidden = false
                case .hoursError:
                    self.baseView.viewState(hstate: .hoursError(""))
                case .registerData:
                    self.viewModel.didGoToRegisterView.onNext(())
                }
            })
            .disposed(by: viewModel.myDisposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        baseView.firstSubProgress.updateColor()
        baseView.secondSubProgress.updateColor()
        baseView.thirdSubProgress.updateColor()
        baseView.fourthSubProgress.updateColor()
    }
}



    
