
////
////  PersonalRegisterViewModel.swift
////  OClock
////
////  Created by Rafael Hartmann on 08/01/22.
////
//
//import Foundation
//import RxSwift
//
//protocol PersonalRegisterViewModelProtocol {
//    typealias Target = PersonalRegisterViewCoordinator.Target
//    
//    var didTapBackButton: AnyObserver<Void> { get }
//    var navigationTarget: Observable<Target> { get }
//    
//    var userImageInput: AnyObserver<UIImage> { get }
//    var userImageOutput: Observable<UIImage> { get }
//}
//
//class PersonalRegisterViewModel: PersonalRegisterViewModelProtocol {
//    
//    let didTapBackButton: AnyObserver<Void>
//    let navigationTarget: Observable<Target>
//    let myDisposeBag = DisposeBag()
//    
//    let userImageInput: AnyObserver<UIImage>
//    let userImageOutput: Observable<UIImage>
//    
//    init(service: PersonalRegisterViewServiceProtocol = PersonalRegisterViewService()) {
//        
//        let _didTapBackButton = PublishSubject<Void>()
//        didTapBackButton = _didTapBackButton.asObserver()
//        
//        let _userImage = PublishSubject<UIImage>()
//        userImageInput = _userImage.asObserver()
//        
//        userImageOutput = _userImage.map { $0 }
//        
//        navigationTarget = Observable.merge(
//            _didTapBackButton.map { .pop }
//        )
//        
//    }
//    
//}
