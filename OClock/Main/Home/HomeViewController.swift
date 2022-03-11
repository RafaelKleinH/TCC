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
        viewModel.timer.fire()
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
            .subscribe(onNext: { value in
                print(value)
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.userData
            .subscribe()
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.usableHoursData
            .subscribe(onNext: { totalBreak, totalHours, hasBreak in
                
                self.baseView.circularProgress.startProgress(angle: 290, time: TimeInterval(totalHours))
                self.baseView.circularProgress.pauseProgress()
                if let hasBreak = hasBreak {
                    self.baseView.addSubProgress(hasBreak: hasBreak)
                    if hasBreak {
                        self.baseView.firstSubProgress.progress.circularProgress.animate(toAngle: 360, duration: TimeInterval(5)) { [weak self] _ in
                            guard let self = self else { return }
                            self.viewModel.isFirstFinished = true
                        }
                        self.baseView.firstSubProgress.progress.pauseProgress()
                        
                        self.baseView.secondSubProgress.progress.circularProgress.animate(toAngle: 360, duration: TimeInterval(5)) { [weak self] _ in
                            guard let self = self else { return }
                            self.viewModel.isSecondFinished = true
                        }
                        self.baseView.secondSubProgress.progress.pauseProgress()
                        
                        self.baseView.thirdSubProgress.progress.circularProgress.animate(toAngle: 360, duration: TimeInterval(5)) { [weak self] _ in
                            guard let self = self else { return }
                            self.viewModel.isThirdFinished = true
                        }
                        self.baseView.thirdSubProgress.progress.pauseProgress()
                        
                        self.baseView.fourthSubProgress.progress.circularProgress.animate(toAngle: 360, duration: TimeInterval(5)) { [weak self] _ in
                            guard let self = self else { return }
                            self.viewModel.isFourthFinished = true
                        }
                        self.baseView.fourthSubProgress.progress.pauseProgress()
                   
                    
                    } else {
                        
                        self.baseView.thirdSubProgress.titleLabel.text = "Total"
                        self.baseView.thirdSubProgress.progress.circularProgress.animate(toAngle: 360, duration: TimeInterval(5)) { [weak self] _ in
                            guard let self = self else { return }
                            self.viewModel.isThirdFinished = true
                        }
                        self.baseView.thirdSubProgress.progress.pauseProgress()
                        
                        self.baseView.fourthSubProgress.progress.circularProgress.animate(toAngle: 360, duration: TimeInterval(5)) { [weak self] _ in
                            guard let self = self else { return }
                            self.viewModel.isFourthFinished = true
                        }
                        self.baseView.fourthSubProgress.progress.pauseProgress()
                    }
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
            .subscribe(onNext: { hasBrk in
                guard let hasBreak = hasBrk else { return }
                
                if hasBreak {
                    if self.viewModel.isOpen {
                        self.viewModel.pauseTimer()
                        self.baseView.circularProgress.pauseProgress()
                        if self.viewModel.isFirstFinished == false {
                            self.baseView.firstSubProgress.progress.pauseProgress()
                        }
                        else if self.viewModel.isThirdFinished == false {
                            self.baseView.thirdSubProgress.progress.pauseProgress()
                        }
                        else if self.viewModel.isFourthFinished == false {
                            self.baseView.fourthSubProgress.progress.pauseProgress()
                        }
                        
                        if self.viewModel.isSecondFinished == false {
                            self.baseView.secondSubProgress.progress.resumeProgress()
                        }
                     
                        self.viewModel.saveHours(inOrOut: "Out: ")
                    } else {
                        self.viewModel.startTime(self)
                        self.baseView.circularProgress.resumeProgress()
                        self.baseView.firstSubProgress.progress.resumeProgress()
                        self.baseView.secondSubProgress.progress.pauseProgress()
                        self.viewModel.saveHours(inOrOut: "In: ")
                    }
                } else {
                    if self.viewModel.isOpen {
                        self.viewModel.pauseTimer()
                        if self.viewModel.isThirdFinished == false {
                            
                        }
                        self.baseView.circularProgress.pauseProgress()
                        self.baseView.thirdSubProgress.progress.pauseProgress()
                        self.viewModel.saveHours(inOrOut: "Out: ")
                    } else {
                        self.viewModel.startTime(self)
                        self.baseView.circularProgress.resumeProgress()
                        self.baseView.thirdSubProgress.progress.resumeProgress()
                        self.viewModel.saveHours(inOrOut: "In: ")
                    }
                }
            })
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.timeButton.rx.tap
            .bind(to: viewModel.didTapButton)
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.stringTime
            .subscribe(onNext: { (a,b) in
                self.baseView.timeLabel.rx.text.onNext(a)
                let hasBreak = self.viewModel.hasBreak
                if hasBreak {
                    if self.viewModel.isOpen {
                        if self.viewModel.isFirstFinished && self.viewModel.isThirdFinished == false {
                            self.baseView.firstSubProgress.progress.pauseProgress()
                            NotificationsCentral.normalNotification()
                            self.baseView.thirdSubProgress.progress.resumeProgress()
                        }
                        if self.viewModel.isSecondFinished && self.viewModel.isThirdFinished == false {
                            self.baseView.secondSubProgress.progress.pauseProgress()
                        }
                        if self.viewModel.isThirdFinished && self.viewModel.isFourthFinished == false {
                            self.baseView.thirdSubProgress.progress.pauseProgress()
                            self.baseView.fourthSubProgress.progress.resumeProgress()
                        } else if self.viewModel.isThirdFinished && self.viewModel.isFourthFinished {
                            self.baseView.fourthSubProgress.progress.pauseProgress()
                        }
                    }
                } else {
                    if self.viewModel.isOpen {
                        if self.viewModel.isThirdFinished && self.viewModel.isFourthFinished == false {
                            self.baseView.thirdSubProgress.progress.pauseProgress()
                            self.baseView.fourthSubProgress.progress.resumeProgress()
                        } else if self.viewModel.isThirdFinished && self.viewModel.isFourthFinished {
                                self.baseView.fourthSubProgress.progress.pauseProgress()
                        }
                    }
                }
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
