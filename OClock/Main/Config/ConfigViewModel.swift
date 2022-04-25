//
//  ConfigViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 18/01/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol ConfigViewModelProtocol {
    typealias Target = MainTabBarCoordinator.TargetC
    
    var navBarTitle: String { get }
    
    var navigationTarget: Observable<Target> { get }
    var logoffBack: Observable<Void> { get }
    var logOffText: Observable<String> { get }
    var hourRegister: Observable<String> { get }
    
    var didClickLogoff: AnyObserver<Void> { get }
    var didClickHoursRegister: AnyObserver<Void> { get }
    
    var myDisposeBag: DisposeBag { get }
    
}

class ConfigViewModel: ConfigViewModelProtocol {
    
    let navigationTarget: Observable<Target>

    let logOffText: Observable<String>
    let hourRegister: Observable<String>
    let navBarTitle: String
    let logoffBack: Observable<Void>
    
    let didClickHoursRegister: AnyObserver<Void>
    let didClickLogoff: AnyObserver<Void>
    let didPop: AnyObserver<Void>
    
    let myDisposeBag = DisposeBag()
    
    var timerCentral: TimerCentral
    
    init(timerCentral: TimerCentral, service: ConfigViewService = ConfigViewService()) {
    
        self.timerCentral = timerCentral
        
        let _didPop = PublishSubject<Void>()
        didPop = _didPop.asObserver()
        
        let _didClickLogoff = PublishSubject<Void>()
        didClickLogoff = _didClickLogoff.asObserver()
        
        let _didClickHoursRegister = PublishSubject<Void>()
        didClickHoursRegister = _didClickHoursRegister.asObserver()
        
        navBarTitle = "ConfigViewNavBarTitle".localized()
        hourRegister = .just("ConfigViewHourRegisterButtonTitle".localized())
        logOffText = .just("ConfigViewLogOffButtonTitle".localized())
        
        logoffBack = _didClickLogoff
            .flatMapLatest {
                service.logoff(timerCentral: timerCentral)
                    .asObservable()
                    .observe(on: MainScheduler.instance)
                    .do(onNext: { _didPop.onNext(()) },
                        onSubscribe: { })
                    .catchError({ error in
                           return Observable.empty()
                    })
                
            }.share()
        
        navigationTarget = Observable.merge(
            _didPop.map({ .logoff }),
            _didClickHoursRegister.map({ .registerHours })
        )
    }
}
