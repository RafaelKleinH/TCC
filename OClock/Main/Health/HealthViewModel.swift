//
//  HealthViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 15/03/22.
//

import Foundation
import RxSwift

protocol HealthViewModelProtocol {
    typealias Target = MainTabBarCoordinator.TargetHealth
    
    var navBarTitle: String { get }
    
    var timerCentral: TimerCentral { get }
    var myDisposeBag: DisposeBag { get }
    var isOpen: Bool { get set }
    var isOn: AnyObserver<Bool> { get }
    var isOnOpen: Observable<Bool> { get }
    var didLoad: AnyObserver<Void> { get }
    var didTapTableViewCell: AnyObserver<Void> { get }
    var selectedRow: AnyObserver<Int> { get }
    var dataReceive: Observable<Void> { get }
    var titles: Observable<[String]> { get }
    var explicationOpenText: Observable<String> { get }
    var explicationText: Observable<String> { get }
    var switchLabelText: Observable<String> { get }
    var navigationTarget: Observable<Target> { get }
}

class HealthViewModel: HealthViewModelProtocol {
    
    let navBarTitle: String = "healthViewNavBarTitle".localized()
    var isOpen = false
    var timerCentral: TimerCentral
    let myDisposeBag = DisposeBag()
    
    let didTapTableViewCell: AnyObserver<Void>
    let selectedRow: AnyObserver<Int>
    let isOn: AnyObserver<Bool>
    let isOnOpen: Observable<Bool>
    let dataReceive: Observable<Void>
    
    let didLoad: AnyObserver<Void>
    let titles: Observable<[String]>
    let explicationOpenText: Observable<String>
    let explicationText: Observable<String>
    let switchLabelText: Observable<String>
    let navigationTarget: Observable<Target>
    
    init(timerCentral: TimerCentral, service: HealthServiceProtocol = HealthService()) {
        self.timerCentral = timerCentral
        
        let _didTapTableViewCell = PublishSubject<Void>()
        didTapTableViewCell = _didTapTableViewCell.asObserver()
        
        let _selectedRow = PublishSubject<Int>()
        selectedRow = _selectedRow.asObserver()
        
        let _isOn = PublishSubject<Bool>()
        isOn = _isOn.asObserver()
        
        let _didLoad = PublishSubject<Void>()
        didLoad = _didLoad.asObserver()
        
        explicationOpenText = .just("healthWantToKnow".localized())
        explicationText = .just("healthViewExplanation".localized())
        switchLabelText = .just("healthViewActivateText".localized())
        
        titles = .just(["firstAdvertiseTitle".localized(),
                       "secondAdvertiseTitle".localized(),
                       "thirdAdvertiseTitle".localized(),
                       "fourthAdvertiseTitle".localized()])
        
        dataReceive = _isOn
            .do(onNext: { bool in
                timerCentral.healthTrigger(healthBool: bool)
            })
            .flatMap { isOn in
            service.postIsOpen(value: isOn)
                .asObservable()
        }.share()
        
        isOnOpen = _didLoad.flatMap({ _ in
            service.getIsOpen()
                .asObservable()
        }).share()
        
        navigationTarget = Observable.merge(
            _didTapTableViewCell.withLatestFrom(_selectedRow).map { .nextView(selected:$0) }
        )
        
    }
}
