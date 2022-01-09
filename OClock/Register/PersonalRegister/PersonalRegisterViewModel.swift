//
//  PersonalRegisterViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 08/01/22.
//

import Foundation
import RxSwift

protocol PersonalRegisterViewModelProtocol {
    typealias Target = PersonalRegisterViewCoordinator.Target
    
    var didTapBackButton: AnyObserver<Void> { get }
    var navigationTarget: Observable<Target> { get }
}

class PersonalRegisterViewModel: PersonalRegisterViewModelProtocol {
    
    let didTapBackButton: AnyObserver<Void>
    let navigationTarget: Observable<Target>
    let myDisposeBag = DisposeBag()
    
    
    init(service: PersonalRegisterViewServiceProtocol = PersonalRegisterViewService()) {
        
        let _didTapBackButton = PublishSubject<Void>()
        didTapBackButton = _didTapBackButton.asObserver()
        
        navigationTarget = Observable.merge(
            _didTapBackButton.map { .pop }
        )
        
    }
    
}
