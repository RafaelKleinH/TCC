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
    case personalError(_: String)
    case personalLoading
    case personalData
    case hoursError(_: String)
    case hoursLoading
    case hoursData
}

protocol HomeViewModelProtocol {
    typealias Target = MainTabBarCoordinator.TargetH
    
    func saveHours(inOrOut: String)
    func pauseTimer()
    func startTime(_ sender: Any)
    
    var navigationTarget: Observable<Target> { get }
    
    var didTapBackButton: AnyObserver<Void> { get }
    var didGoToRegisterView: AnyObserver<Void> { get }
    var didViewLoad: AnyObserver<Void> { get }
    var didLoadUserData: AnyObserver<Void> { get }
    
    var hoursData: Observable<HoursData> { get }
    var userData: Observable<PersonalData> { get }
    
    var timer: Timer { get }
    var timerNum: Int { get }
    var stringTime: Observable<String> { get }
    var midTime: AnyObserver<Int> { get }
    
    var state: Observable<HomeState> { get }
    
    var myDisposeBag: DisposeBag { get }
    
    var isOpen: Bool { get }
    
    
    var totalHours: Observable<Int> { get }
    var totalBreakHours: Observable<Int> { get }
    var userName: Observable<String> { get }
    var ableFakedRegister: BehaviorRelay<[String]> { get }
}

class HomeViewModel: HomeViewModelProtocol {
    
    let navigationTarget: Observable<Target>
    
    let didTapBackButton: AnyObserver<Void>
    let didGoToRegisterView: AnyObserver<Void>
    let didViewLoad: AnyObserver<Void>
    let didLoadUserData: AnyObserver<Void>
    
    let hoursData: Observable<HoursData>
    let userData: Observable<PersonalData>
    
    let state: Observable<HomeState>
    
    var timer = Timer()
    var timerNum: Int = 0
    var stringTime: Observable<String>
    var midTime: AnyObserver<Int>
    
    let isRunning: AnyObserver<Bool>
    
    let myDisposeBag = DisposeBag()
    
    var isOpen: Bool = false
    
    
    //MARK:- Models

    var userName: Observable<String>
    let totalHours: Observable<Int>
    let totalBreakHours: Observable<Int>
    let ableFakedRegister: BehaviorRelay<[String]> = .init(value: [])
    
    init(service: HomeViewServiceProtocol = HomeViewService()) {
        
        let _didTapBackButton = PublishSubject<Void>()
        didTapBackButton = _didTapBackButton.asObserver()
        
        let _didViewLoad = PublishSubject<Void>()
        didViewLoad = _didViewLoad.asObserver()
        
        let _didLoadUserData = PublishSubject<Void>()
        didLoadUserData = _didLoadUserData.asObserver()
        
        let _state = PublishSubject<HomeState>()
        state = _state.asObserver()
        
        let _didGoToRegisterView = PublishSubject<Void>()
        didGoToRegisterView = _didGoToRegisterView.asObserver()
        
        let _isRunning = PublishSubject<Bool>()
        isRunning = _isRunning.asObserver()
        
        let _midTime = PublishSubject<Int>()
        midTime = _midTime.asObserver()
            
        
        
        
        
        
        stringTime = _midTime.map { a in
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            
            let formattedString = formatter.string(from: TimeInterval(a)) ?? ""
            return formattedString
        }
        
        userData = _didViewLoad.flatMap { _ in
            service.getPersonalData()
                .asObservable()
                .observe(on: MainScheduler.instance)
                .do(onNext: { _ in _state.onNext(.personalData) },
                    onSubscribe: { _state.onNext(.personalLoading) })
                .catchError({ error in
                    _state.onNext(.personalError(error.localizedDescription))
                    return Observable.empty()
                })
        }.share()
        
        userName = userData.map { $0.name }.map { name in
            guard let name = name else { return "Olá :D" }
            let sepName = name.components(separatedBy: " ")
            if let valOne = sepName.first, let valTwo = sepName.last {
                let dale = valOne == valTwo ? valOne : valOne + " " + valTwo
                return dale
            } else {
                return "Olá :D"
            }
        }
     
        hoursData = _didLoadUserData
            .flatMap { _ in
                service.getHoursData()
                    .asObservable()
                    .observe(on: MainScheduler.instance)
                    .do(onNext: { _ in _state.onNext(.hoursData) },
                        onSubscribe: { _state.onNext(.hoursLoading) })
                    .catchError({ error in
                        _state.onNext(.hoursError(error.localizedDescription))
                        return Observable.empty()
                    })

            }.share()
        
        totalHours = hoursData.map({ $0.totalHours }).map({ totalHours in
            guard let hours = totalHours else { return 0 }
            let sepHours = hours.components(separatedBy: ":")
            if let valOne = sepHours.first, let valTwo = sepHours.last {
                if let valOne = Int(valOne), let valTwo = Int(valTwo) {
                    return (valOne * 3600) + (valTwo * 60)
                } else {
                    return 0
                }
            } else {
                return 0
            }
        })
        
        totalBreakHours = hoursData.map({ $0.totalBreakTime }).map({ totalBreakHours in
            guard let hours = totalBreakHours else { return 0 }
            let sepHours = hours.components(separatedBy: ":")
            if let valOne = sepHours.first, let valTwo = sepHours.last {
                if let valOne = Int(valOne), let valTwo = Int(valTwo) {
                    return (valOne * 3600) + (valTwo * 60)
                } else {
                    return 0
                }
            } else {
                return 0
            }
        })
        
        
        
        navigationTarget = Observable.merge(
            _didGoToRegisterView.map { .registerBaseData }
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



