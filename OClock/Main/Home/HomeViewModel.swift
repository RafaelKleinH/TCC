//
//  HomeViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 05/01/22.
//

import Foundation
import RxSwift
import RxRelay

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
    
    var timer: Timer { get }
    var timerNum: Int { get }
    var stringTime: Observable<String> { get }
    var midTime: AnyObserver<Int> { get }
    
    var state: Observable<HomeState> { get }
    
    var myDisposeBag: DisposeBag { get }
    
    var isOpen: Bool { get }
    
    
    var fakeHours: Observable<[Double]> { get }
    
    var ableFakedRegister: BehaviorRelay<[String]> { get }
}

class HomeViewModel: HomeViewModelProtocol {
    
    let navigationTarget: Observable<Target>
    
    let didTapBackButton: AnyObserver<Void>
    let didGoToRegisterView: AnyObserver<Void>
    let didViewLoad: AnyObserver<Void>
    
    let userData: Observable<PersonalData?>
    
    let state: Observable<HomeState>
    
    var timer = Timer()
    var timerNum: Int = 0
    var stringTime: Observable<String>
    var midTime: AnyObserver<Int>
    
    let isRunning: AnyObserver<Bool>
    
    let myDisposeBag = DisposeBag()
    
    var isOpen: Bool = false
    
    let fakeHours: Observable<[Double]>
    let ableFakedRegister: BehaviorRelay<[String]> = .init(value: [])
    
    init(service: HomeViewServiceProtocol = HomeViewService()) {
        
        let _didTapBackButton = PublishSubject<Void>()
        didTapBackButton = _didTapBackButton.asObserver()
        
        let _didViewLoad = PublishSubject<Void>()
        didViewLoad = _didViewLoad.asObserver()
        
        let _state = PublishSubject<HomeState>()
        state = _state.asObserver()
        
        let _didGoToRegisterView = PublishSubject<Void>()
        didGoToRegisterView = _didGoToRegisterView.asObserver()
        
        let _isRunning = PublishSubject<Bool>()
        isRunning = _isRunning.asObserver()
        
        let _midTime = PublishSubject<Int>()
        midTime = _midTime.asObserver()
        
        fakeHours = .just([28800,  3600])
        
        stringTime = _midTime.map { a in
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            
            let formattedString = formatter.string(from: TimeInterval(a)) ?? ""
            return formattedString
        }
        
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
            _didGoToRegisterView.map { .register }
        )
    }
    
    func startTime(_ sender: Any) {
        isOpen = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(action), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        isOpen = false
        timer.invalidate()
    }
    
    @objc func action() {
        timerNum += 1
        midTime.onNext(timerNum)
    }
    
    func saveHours(inOrOut: String) {
        let dateFormatter: DateFormatter = {
            $0.timeZone = .current
            $0.dateFormat = "dd/MM/YY-HH:mm:ss"
            return $0
        }(DateFormatter())
        
        let date = dateFormatter.string(from: Date())
        ableFakedRegister.accept(ableFakedRegister.value + [inOrOut + date])
    }
}



