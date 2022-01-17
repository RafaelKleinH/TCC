//
//  HomeViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 05/01/22.
//

import Foundation
import RxSwift

enum HomeState {
    case personalErro(_: String)
    case personalLoading
    case personalData
}

protocol HomeViewModelProtocol {
    typealias Target = HomeViewCoordinator.Target
    
    var navigationTarget: Observable<Target> { get }
    
    var didTapBackButton: AnyObserver<Void> { get }
    var didGoToRegisterView: AnyObserver<Void> { get }
    var didViewLoad: AnyObserver<Void> { get }
    
    var userData: Observable<PersonalData?> { get }
    
    var state: Observable<HomeState> { get }
    
    var myDisposeBag: DisposeBag { get }
}

class HomeViewModel: HomeViewModelProtocol {
    
    let navigationTarget: Observable<Target>
    
    let didTapBackButton: AnyObserver<Void>
    let didGoToRegisterView: AnyObserver<Void>
    let didViewLoad: AnyObserver<Void>
    
    let userData: Observable<PersonalData?>
    
    let state: Observable<HomeState>
    
    let myDisposeBag = DisposeBag()
    
    init(service: HomeViewServiceProtocol = HomeViewService()) {
        
        let _didTapBackButton = PublishSubject<Void>()
        didTapBackButton = _didTapBackButton.asObserver()
        
        let _didViewLoad = PublishSubject<Void>()
        didViewLoad = _didViewLoad.asObserver()
        
        let _state = PublishSubject<HomeState>()
        state = _state.asObserver()
        
        let _didGoToRegisterView = PublishSubject<Void>()
        didGoToRegisterView = _didGoToRegisterView.asObserver()
        
        userData = _didViewLoad.flatMapLatest { _ in
            service.largato()
                .asObservable()
                .observe(on: MainScheduler.instance)
                .do(onNext: { _ in _state.onNext(.personalData) },
                    onSubscribe: { _state.onNext(.personalLoading) })
                .catchError({ error in
                    _state.onNext(.personalErro(error.localizedDescription))
                    return Observable.empty()
                })
        }.share()
        
        navigationTarget = Observable.merge(
            _didTapBackButton.map { .pop },
            _didGoToRegisterView.map { .register }
        )
    }
}

