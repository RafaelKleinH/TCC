
//
//  PersonalRegisterViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 08/01/22.
//

import Foundation
import RxSwift

enum PersonalRegisterState {
    case loading
    case success
    case initial
    case error(_: String)
}

protocol PersonalRegisterViewModelProtocol {
    typealias Target = PersonalRegisterViewCoordinator.Target
    
    var state: Observable<PersonalRegisterState> { get }
    
    var nameTextFieldPlaceholder: Observable<String> { get }
    var occupationTextFieldPlaceholder: Observable<String> { get }
    var explicationLabelTitle: Observable<String> { get }
    var registerButtonTitle: Observable<String> { get }
    
    var didGoToNextView: AnyObserver<Void> { get }
    var didTapBackButton: AnyObserver<Void> { get }
    
    var navigationTarget: Observable<Target> { get }
    
    var loadData: AnyObserver<Void> { get }
    
    var userImageInput: AnyObserver<UIImage> { get }
    var userImageOutput: Observable<UIImage> { get }
    
    var nameText: AnyObserver<String> { get }
    var occupationText: AnyObserver<String> { get }

    var requests: Observable<Bool> { get }
    
    var myDisposeBag: DisposeBag { get }
}

class PersonalRegisterViewModel: PersonalRegisterViewModelProtocol {
    
    let myDisposeBag = DisposeBag()
    
    let nameTextFieldPlaceholder: Observable<String> = .just("PersonalRegisterName".localized())
    let occupationTextFieldPlaceholder: Observable<String> = .just("PersonalRegisterOccupation".localized())
    let explicationLabelTitle: Observable<String> = .just("PersonalRegisterExplication".localized())
    let registerButtonTitle: Observable<String> = .just("PersonalRegisterButton".localized())
    
    let didGoToNextView: AnyObserver<Void>
    let didTapBackButton: AnyObserver<Void>
    let navigationTarget: Observable<Target>
    
    let state: Observable<PersonalRegisterState>
    
    let userImageInput: AnyObserver<UIImage>
    let userImageOutput: Observable<UIImage>
    
    let loadData: AnyObserver<Void>
    
    let nameText: AnyObserver<String>
    let occupationText: AnyObserver<String>
    
    let requests: Observable<Bool>
    
    init(service: PersonalRegisterViewServiceProtocol = PersonalRegisterViewService()) {
        
        let _didTapBackButton = PublishSubject<Void>()
        didTapBackButton = _didTapBackButton.asObserver()
        
        let _userImage = PublishSubject<UIImage>()
        userImageInput = _userImage.asObserver()
        
        let _loadData = PublishSubject<Void>()
        loadData = _loadData.asObserver()
        
        let _nameText = PublishSubject<String>()
        nameText = _nameText.asObserver()
        
        let _occupupationText = PublishSubject<String>()
        occupationText = _occupupationText.asObserver()
        
        let _didGoToNextView = PublishSubject<Void>()
        didGoToNextView = _didGoToNextView.asObserver()
        
        let _state = PublishSubject<PersonalRegisterState>()
        state = _state.asObserver()
        
        _state.onNext(.initial)
        
        userImageOutput = _userImage.map { $0 }
        
        requests = _loadData.withLatestFrom(Observable.combineLatest(_nameText, _occupupationText, _userImage))
            .filter({ name, occupation, _ in
                name != "" && occupation != ""
            }).flatMapLatest { name, occupationText, image in
                service.postInformations(name: name, occupation: occupationText, image: image)
                    .asObservable()
                    .observe(on: MainScheduler.instance)
                    .do(onNext: { _ in _state.onNext(.success) },
                        onSubscribe: { _state.onNext(.loading) })
                    .catchError { error in
                        _state.onNext(.error(error.localizedDescription))
                        return Observable.empty()
                    }
            }.share()
            
        
        navigationTarget = Observable.merge(
            _didTapBackButton.map { .pop },
            _didGoToNextView.map { .nextView }
        )
        
    }
    
}
