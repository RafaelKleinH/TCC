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
    var didClickLogoff: AnyObserver<Void> { get }
}

class ConfigViewModel: ConfigViewModelProtocol {
    
    let didClickLogoff: AnyObserver<Void>
    let logoffBack: Observable<Void>
    let didPop: AnyObserver<Void>
    
    init(service: ConfigViewService = ConfigViewService()) {
    
        let _didPop = PublishSubject<Void>()
        didPop = _didPop.asObserver()
        
        let _didClickLogoff = PublishSubject<Void>()
        didClickLogoff = _didClickLogoff.asObserver()
        
        logoffBack = _didClickLogoff
            .flatMapLatest {
                service.logoff()
                    .asObservable()
                    .observe(on: MainScheduler.instance)
                    .do(onNext: { _didPop.onNext(()) },
                        onSubscribe: { print("subs") })
                
            }.share()
    }
}
