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
            .subscribe(onNext: {  data in
                if data.name != "" {
                    self.viewModel.didGoToRegisterView.onNext(())
                } else {
                    self.viewModel.didLoadUserData.onNext(())
                }
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.hoursData
            .subscribe()
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.ableFakedRegister
            .subscribe(onNext: { value in
                print(value)
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.userData
            .subscribe()
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.totalBreakHours
            .subscribe(onNext: { interger in
                self.baseView.secondSubProgress.progress.startProgress(angle: 360, time: TimeInterval(interger))
                self.baseView.secondSubProgress.progress.pauseProgress()
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.totalHours
            .subscribe(onNext: { interger in
                print("DEBUGS:\(interger)")
                self.baseView.circularProgress.startProgress(angle: 290, time: TimeInterval(interger))
                self.baseView.circularProgress.pauseProgress()
                
                self.baseView.firstSubProgress.progress.startProgress(angle: 360, time: TimeInterval(interger / 2))
                self.baseView.firstSubProgress.progress.pauseProgress()
                
               
            })
            .disposed(by: viewModel.myDisposeBag)

        baseView.timeButton.rx.tap
            .subscribe({ [weak self] _ in
                guard let self = self else { return }
                if self.viewModel.isOpen {
                    self.viewModel.pauseTimer()
                    self.baseView.circularProgress.pauseProgress()
                    self.baseView.firstSubProgress.progress.pauseProgress()
                    self.baseView.secondSubProgress.progress.resumeProgress()
                    self.viewModel.saveHours(inOrOut: "Out: ")
                } else {
                    self.viewModel.startTime(self)
                    self.baseView.circularProgress.resumeProgress()
                    self.baseView.firstSubProgress.progress.resumeProgress()
                    self.baseView.secondSubProgress.progress.pauseProgress()
                    self.viewModel.saveHours(inOrOut: "In: ")
                }
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.stringTime
            .bind(to: baseView.timeLabel.rx.text)
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.userName
            .bind(to: baseView.nameLabel.rx.text)
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.state
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .personalLoading:
                    self.baseView.scrollView.isHidden = true
                    self.baseView.indicatorView.startAnimating()
                case .personalData:
                    print("laland")
                case let .personalError(error):
                    print("DEBUG: 3 \(error)")
                case .hoursLoading:
                    print("DEBUG: 4")
                case .hoursData:
                    self.baseView.indicatorView.stopAnimating()
                    self.baseView.scrollView.isHidden = false
                case let .hoursError(error):
                    print("DEBUG: 6 \(error)")
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
