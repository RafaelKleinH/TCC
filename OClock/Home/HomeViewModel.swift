//
//  HomeViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 05/01/22.
//

import Foundation
import RxSwift

protocol HomeViewModelProtocol {
    typealias Target = HomeViewCoordinator.Target
    
    var navigationTarget: Observable<Target> { get }
    
    var didTapBackButton: Observable<Void> { get }
    
    var myDisposeBag: DisposeBag { get }
}

class HomeViewModel: HomeViewModelProtocol {
    
    let navigationTarget: Observable<Target>
    
    let didTapBackButton: Observable<Void>
    
    let myDisposeBag = DisposeBag()
    
    init() {
        
        let _didTapBackButton = PublishSubject<Void>()
        didTapBackButton = _didTapBackButton.asObserver()
        
        navigationTarget = Observable.merge(
            _didTapBackButton.map { .pop }
        )
    }
}

