//
//  HomeViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 05/01/22.
//

import Foundation
import RxSwift
import RxRelay

enum HomeState: Equatable {
    case personalError(_: String)
    case personalLoading
    case personalData
    case hoursError(_: String)
    case hoursLoading
    case hoursData
    case registerData
}

protocol HomeViewModelProtocol {
    typealias Target = MainTabBarCoordinator.TargetH
    
    func calculatePercentage(value: Double ,min: Double, max: Double) -> Double
    
    var initStateController: HomeState? { get set }
    
    var navigationTarget: Observable<Target> { get }
    
    var timerCentral: TimerCentral { get }
    
    var afterReturnBackGround: Bool { get set }
    
    var didTapButton: AnyObserver<Void> { get }
    var didGoToPersonalRegister: AnyObserver<Void> { get }
    var didTapBackButton: AnyObserver<Void> { get }
    var didGoToRegisterView: AnyObserver<Void> { get }
    var didViewLoad: AnyObserver<Void> { get }
    var didLoadUserData: AnyObserver<Void> { get }
    
    var buttonBack: Observable<Bool?> { get }
    var hoursData: Observable<HoursData> { get }
    var userData: Observable<PersonalData> { get }
    
    var stringTime: Observable<(String, Double)> { get }
    
    var state: Observable<HomeState> { get }
    
    var myDisposeBag: DisposeBag { get }
    
    var userImage: Observable<UIImage> { get }
    var hasBreak: Bool { get set }
    var isFirstFinished: Bool { get set }
    var isSecondFinished: Bool { get set }
    var isThirdFinished: Bool { get set }
    var isFourthFinished: Bool { get set }
    
    var usableHoursData: Observable<(Int, Int, Bool?)> { get }
    
    var totalHours: Observable<Int> { get }
    var ableFakedRegister: BehaviorRelay<[String]> { get }
    var totalBreakHours: Observable<Int> { get }
    var userName: Observable<String> { get }
    
    var didLongPressButton: AnyObserver<Void> { get }
    var didReturnLongPress: Observable<Void> { get }
}

class HomeViewModel: HomeViewModelProtocol {
    
    let navigationTarget: Observable<Target>
    var initStateController: HomeState?
    let didTapButton: AnyObserver<Void>
    let didGoToPersonalRegister: AnyObserver<Void>
    let didTapBackButton: AnyObserver<Void>
    let didGoToRegisterView: AnyObserver<Void>
    let didViewLoad: AnyObserver<Void>
    let didLoadUserData: AnyObserver<Void>
    
    let buttonBack: Observable<Bool?>
    let hoursData: Observable<HoursData>
    let userData: Observable<PersonalData>
    
    let state: Observable<HomeState>
    
    let stringTime: Observable<(String, Double)>
    
    let isRunning: AnyObserver<Bool>
    
    let myDisposeBag = DisposeBag()
    
    var isOpen: Bool = false
    var hasBreak: Bool = false
    var isFirstFinished: Bool = false
    var isSecondFinished: Bool = false
    var isThirdFinished: Bool = false
    var isFourthFinished: Bool = false
    var afterReturnBackGround: Bool = false
    
    let usableHoursData: Observable<(Int, Int, Bool?)>
    //MARK: Models
    
    let userImage: Observable<UIImage>
    let userName: Observable<String>
    let totalHours: Observable<Int>
    let totalBreakHours: Observable<Int>
    let ableFakedRegister: BehaviorRelay<[String]> = .init(value: [])
    
    let didLongPressButton: AnyObserver<Void>
    let didReturnLongPress: Observable<Void>
    
    var timerCentral: TimerCentral
    
    init(timerCentral: TimerCentral, service: HomeViewServiceProtocol = HomeViewService()) {
        
        self.timerCentral = timerCentral
        
        let _didTapButton = PublishSubject<Void>()
        didTapButton = _didTapButton.asObserver()
        
        let _didGoToPersonalRegister = PublishSubject<Void>()
        didGoToPersonalRegister = _didGoToPersonalRegister.asObserver()
        
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

        let _didLongPressButton = PublishSubject<Void>()
        didLongPressButton = _didLongPressButton.asObserver()
        
        didReturnLongPress = _didLongPressButton.map { $0 }
        
        stringTime = timerCentral.midTime.map { a in
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            
            let formattedString = formatter.string(from: TimeInterval(a)) ?? ""
            return (formattedString, Double(a))
        }
        
        
        
        userData = _didViewLoad.flatMap { _ in
            service.getPersonalData()
                .asObservable()
                .observe(on: MainScheduler.instance)
                .do(onNext: { usrdata in
                    //TODO extendion que valida tudo
                    if usrdata.name == nil || usrdata.name == ""{
                        _state.onNext(.registerData)
                    } else {
                        _state.onNext(.personalData)
                    }
                },
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
                    .do(onNext: { hrsData in
                        //TODO funcao que valida isso
                        if hrsData.startHours == nil {
                            _state.onNext(.registerData)
                        } else {
                            _state.onNext(.hoursData)
                        }
                    },
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
        
        usableHoursData = Observable.combineLatest(totalBreakHours, totalHours, hoursData.map { $0.hasBreak })

        buttonBack = _didTapButton.withLatestFrom(hoursData.map { $0.hasBreak })
        
        
        userImage = _didViewLoad.flatMap({ _ in
            service.getImage()
                .asObservable()
                .observe(on: MainScheduler.instance)
        }).share()
        
        navigationTarget = Observable.merge(
            _didGoToRegisterView.map { .registerBaseData },
            _didGoToPersonalRegister.withLatestFrom(userData).map { .personalRegister(userData:$0) }
        )
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
    
    func calculatePercentage(value: Double ,min: Double, max: Double) -> Double{
        return ((value - min) * 100 ) / (max - min)
    }
}



