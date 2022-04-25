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
        
        viewModel.timerCentral.intervalStartTime =  viewModel.timerCentral.userDefaults.object(forKey:  viewModel.timerCentral.INTERVAL_START_TIME_KEY) as? Date
        
        viewModel.timerCentral.intervalStopTime =  viewModel.timerCentral.userDefaults.object(forKey:  viewModel.timerCentral.INTERVAL_STOP_TIME_KEY) as? Date
        
        viewModel.timerCentral.intervalIsOpen = viewModel.timerCentral.userDefaults.bool(forKey: viewModel.timerCentral.INTERVAL_COUNTING_KEY)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        let needReload = UserDefaults.standard.bool(forKey: UserDefaultValue.NEED_RELOAD.rawValue)
        if needReload == true {
            viewModel.didViewLoad.onNext(())
            viewModel.timerCentral.startTime = viewModel.timerCentral.userDefaults.object(forKey: viewModel.timerCentral.START_TIME_KEY) as? Date
            
            viewModel.timerCentral.stopTime = viewModel.timerCentral.userDefaults.object(forKey: viewModel.timerCentral.STOP_TIME_KEY) as? Date
            
            viewModel.timerCentral.isOpen = viewModel.timerCentral.userDefaults.bool(forKey: viewModel.timerCentral.COUNTING_KEY)
            
            viewModel.timerCentral.intervalStartTime =  viewModel.timerCentral.userDefaults.object(forKey: viewModel.timerCentral.INTERVAL_START_TIME_KEY) as? Date
            
            viewModel.timerCentral.intervalStopTime =  viewModel.timerCentral.userDefaults.object(forKey: viewModel.timerCentral.INTERVAL_STOP_TIME_KEY) as? Date
            
            viewModel.timerCentral.intervalIsOpen = viewModel.timerCentral.userDefaults.bool(forKey: viewModel.timerCentral.INTERVAL_COUNTING_KEY)
           
        }
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
        
        viewModel.userImage
            .bind(to: baseView.personalImageView.rx.image)
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.usableHoursData
            .subscribe(onNext: { [weak self] totalBreak, totalHours, hasBreak in
                guard let self = self else { return }
                let needReload = UserDefaults.standard.bool(forKey: UserDefaultValue.NEED_RELOAD.rawValue)
                self.viewModel.timerCentral.totalHours = totalHours
                self.viewModel.timerCentral.hasBreak = hasBreak
                self.viewModel.timerCentral.intervalTotalHours = totalBreak
                if let hasBreak = hasBreak {
                    self.baseView.addSubProgress(hasBreak: hasBreak)
                }
                
                if self.viewModel.timerCentral.intervalIsOpen && needReload == false {
                    //MARK: Interval
                    self.viewModel.timerCentral.intervalStartHelper()
                   
                } else if self.viewModel.timerCentral.intervalIsOpen == false && needReload == false {
                    self.viewModel.timerCentral.intervalStopTimer()
                    if let startTime = self.viewModel.timerCentral.intervalStartTime {
                        if let stopTime = self.viewModel.timerCentral.intervalStopTime {
                            let time = self.viewModel.timerCentral.calcRestartTime(start: startTime, stop: stopTime)
                            let diff = Date().timeIntervalSince(time)
                            self.viewModel.timerCentral.intervalMidTime.onNext(Int(diff))
                            
                        }
                    }
                }
                
                if  self.viewModel.timerCentral.isOpen && needReload == false {
                    self.viewModel.timerCentral.startHelper()
                } else if self.viewModel.timerCentral.isOpen == false && needReload == false {
                    //MARK: NormalTimer
                    self.viewModel.timerCentral.stopTimer()
                    if let startTime = self.viewModel.timerCentral.startTime {
                        if let stopTime = self.viewModel.timerCentral.stopTime {
                            let time = self.viewModel.timerCentral.calcRestartTime(start: startTime, stop: stopTime)
                            let diff = Date().timeIntervalSince(time)
                            self.viewModel.timerCentral.midTime.onNext(Int(diff))
                        }
                    }  
                }
                UserDefaults.standard.set(false, forKey: UserDefaultValue.NEED_RELOAD.rawValue)
                
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.timerCentral
            .intervalMidTime
            .subscribe(onNext: { [weak self] time in
                guard let self = self, let totalHours = self.viewModel.timerCentral.intervalTotalHours else { return }
                let num = Double(time)
                let secondSub = self.viewModel.calculatePercentage(value: num, min: 0.0, max: Double(totalHours))
                if secondSub < 100.0 {
                    UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                        self.baseView.secondSubProgress.progressLabel.rx.text.onNext("\(secondSub.rounded(toPlaces: 1))%")
                        self.baseView.secondSubProgress.progress.circularProgress.progress = secondSub / 100
                    }, completion: nil)
                } else {
                    UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                        self.baseView.secondSubProgress.progressLabel.rx.text.onNext("100.0%")
                        self.baseView.secondSubProgress.progress.circularProgress.progress = 1.0
                    }, completion: nil)
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
               
                let mainProgress = self.viewModel.calculatePercentage(value: num, min: 0.0, max: Double(totalHours))
                mainProgressValue = mainProgress / 125
                if mainProgressValue == 0 {
                    self.baseView.circularProgress.circularProgress.progress = 0.0
                } else if mainProgressValue < 0.81 {
                    self.baseView.circularProgress.circularProgress.progress = mainProgress / 125
                } else {
                    self.baseView.circularProgress.circularProgress.progress = 0.81
                }
                    
                if hasBreak == true {
                    let firstSub = self.viewModel.calculatePercentage(value: num, min: 0.0, max: Double(halfHours))
                    if firstSub < 100.0 {
                        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                            self.baseView.firstSubProgress.progressLabel.rx.text.onNext("\(firstSub.rounded(toPlaces: 1))%")
                            self.baseView.firstSubProgress.progress.circularProgress.progress = firstSub / 100
                        }, completion: nil)
                    } else {
                        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                            self.baseView.firstSubProgress.progressLabel.rx.text.onNext("100.0%")
                            self.baseView.firstSubProgress.progress.circularProgress.progress = 1.0
                        }, completion: nil)
                    }
                    let thirdSub = self.viewModel.calculatePercentage(value: num, min: Double(halfHours), max: Double(totalHours))
                    if thirdSub < 0.0 {
                        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                            self.baseView.thirdSubProgress.progressLabel.rx.text.onNext("0.0%")
                            self.baseView.thirdSubProgress.progress.circularProgress.progress = 0.0
                        }, completion: nil)
                    } else if thirdSub < 100.0 {
                        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                            self.baseView.thirdSubProgress.progressLabel.rx.text.onNext("\(thirdSub.rounded(toPlaces: 1))%")
                            self.baseView.thirdSubProgress.progress.circularProgress.progress = thirdSub / 100
                        }, completion: nil)
                    } else {
                        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                            self.baseView.thirdSubProgress.progressLabel.rx.text.onNext("100.0%")
                            self.baseView.thirdSubProgress.progress.circularProgress.progress = 1.0
                        }, completion: nil)
                    }
                } else {
                    let thirdSub = self.viewModel.calculatePercentage(value: num, min: Double(0), max: Double(totalHours))
                    if thirdSub < 0.0 {
                        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                            self.baseView.thirdSubProgress.progressLabel.rx.text.onNext("0.0%")
                            self.baseView.thirdSubProgress.progress.circularProgress.progress = 0.0
                        }, completion: nil)
                    } else if thirdSub < 100.0 {
                        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                            self.baseView.thirdSubProgress.progressLabel.rx.text.onNext("\(thirdSub.rounded(toPlaces: 1))%")
                            self.baseView.thirdSubProgress.progress.circularProgress.progress = thirdSub / 100
                        }, completion: nil)
                    } else {
                        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                            self.baseView.thirdSubProgress.progressLabel.rx.text.onNext("100.0%")
                            self.baseView.thirdSubProgress.progress.circularProgress.progress = 1.0
                        }, completion: nil)
                    }
                  
                }
                let fourthMax = totalHours + (3600 * 2)
                let fourthSub = self.viewModel.calculatePercentage(value: num, min: Double(totalHours), max: Double(fourthMax))
                if fourthSub < 0.0 {
                    UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                        self.baseView.fourthSubProgress.progressLabel.rx.text.onNext("0.0%")
                        self.baseView.fourthSubProgress.progress.circularProgress.progress = 0.0
                    }, completion: nil)
                } else if fourthSub < 100.0 {
                    UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                        self.baseView.fourthSubProgress.progressLabel.rx.text.onNext("\(fourthSub.rounded(toPlaces: 1))%")
                        self.baseView.fourthSubProgress.progress.circularProgress.progress = fourthSub / 100
                    }, completion: nil)
                } else {
                    UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                        self.baseView.fourthSubProgress.progressLabel.rx.text.onNext("100.0%")
                        self.baseView.fourthSubProgress.progress.circularProgress.progress = 1.0
                    }, completion: nil)
                }
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.totalBreakHours
            .subscribe()
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.totalHours
            .subscribe()
            .disposed(by: viewModel.myDisposeBag)

        viewModel.buttonBack
            .subscribe(onNext: { [weak self] _ in
                if self?.viewModel.timerCentral.isOpen == true {
                    self?.viewModel.timerCentral.pauseTimer()
                    self?.viewModel.timerCentral.intervalStartTimer()
                } else {
                    self?.viewModel.timerCentral.startTimer()
                    self?.viewModel.timerCentral.intervalPauseTimer()
                }
            })
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.timeButton
            .rx
            .tap
            .bind(to: viewModel.didTapButton)
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.timeButton
            .rx
            .longPressGesture(configuration: .none)
            .skip(1)
            .subscribe(onNext: { [weak self] value in
                if value.state == .began {
                    self?.viewModel.didLongPressButton.onNext(())
                }
            })
            .disposed(by: viewModel.myDisposeBag)
        
        let alert = UIAlertController(title: viewModel.alertTitleText, message: viewModel.alertMessageText, preferredStyle: .alert)
        
        alert
            .addAction(UIAlertAction(title: viewModel.alertCancelText, style: .default, handler: nil))
        
        alert
            .addAction(UIAlertAction(title: viewModel.alertConfirmText, style: .default, handler: { [weak self] _ in
                self?.viewModel.timerCentral.saveDate()
                self?.viewModel.timerCentral.resetAction()
            }))
        
        viewModel.didReturnLongPress
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.stringTime
            .subscribe(onNext: { [weak self] (text, num) in
                self?.baseView.timeLabel.rx.text.onNext(text)
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
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.didGoToPersonalRegister.onNext(())
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.state
            .distinctUntilChanged()
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
                    self.viewModel.initStateController = .registerData
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


