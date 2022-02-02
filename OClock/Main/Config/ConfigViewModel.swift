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
    
    var myDisposeBag: DisposeBag { get }
    
    var didClickLogoff: AnyObserver<Void> { get }
    var didClickHoursRegister: AnyObserver<Void> { get }
    
    var logoffBack: Observable<Void> { get }
    var logOffText: Observable<String> { get }
    var hourRegister: Observable<String> { get }
    var notifiesRegister: Observable<String> { get }
    
    var navigationTarget: Observable<Target> { get }
    
}

class ConfigViewModel: ConfigViewModelProtocol {
    
    let myDisposeBag = DisposeBag()
    
    let didClickHoursRegister: AnyObserver<Void>
    let didClickLogoff: AnyObserver<Void>
    let logoffBack: Observable<Void>
    let didPop: AnyObserver<Void>
    
    let navigationTarget: Observable<Target>
    
    let logOffText: Observable<String>
    let hourRegister: Observable<String>
    let notifiesRegister: Observable<String>
    
    init(service: ConfigViewService = ConfigViewService()) {
    
        let _didPop = PublishSubject<Void>()
        didPop = _didPop.asObserver()
        
        let _didClickLogoff = PublishSubject<Void>()
        didClickLogoff = _didClickLogoff.asObserver()
        
        let _didClickHoursRegister = PublishSubject<Void>()
        didClickHoursRegister = _didClickHoursRegister.asObserver()
        
        hourRegister = .just("Registros dos Horarios")
        notifiesRegister = .just("Opções de Notificações")
        logOffText = .just("Sair")
        
        logoffBack = _didClickLogoff
            .flatMapLatest {
                service.logoff()
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
