//
//  TimeDataRegisterViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 08/01/22.
//

import Foundation
import RxSwift

protocol TimeDataRegisterViewModelProtocol {
 
    typealias Target = TimeDataRegisterViewCoordinator.Target
 
    var disposeBag: DisposeBag { get }
    
    var navigationTarget: Observable<Target> { get }
    
    var didTapBackButton: AnyObserver<Void> { get }
    var didTapBottomButton: AnyObserver<Void> { get }
}

class TimeDataRegisterViewModel: TimeDataRegisterViewModelProtocol {
    
    let disposeBag = DisposeBag()
    
    let navigationTarget: Observable<Target>
    
    let didTapBackButton: AnyObserver<Void>
    let didTapBottomButton: AnyObserver<Void>
    
    init() {
        
        let _didTapBackButton = PublishSubject<Void>()
        didTapBackButton = _didTapBackButton.asObserver()
        
        let _didTapBottomButton = PublishSubject<Void>()
        didTapBottomButton = _didTapBottomButton.asObserver()
        
        navigationTarget = Observable.merge(
            _didTapBackButton.map { .pop }
        )
    }
}

