//
//  SettingVReactor.swift
//  App
//
//  Created by 윤제 on 11/19/24.
//

import Foundation

import Core
import Domain

import ReactorKit

final class SettingReactor: Reactor {
    
    enum SettingList: CaseIterable {
        case restDayUpdate
        case firstWeekday
        case version
        case kakaoLogin
        case theme
        
        var title: String {
            switch self {
            case .restDayUpdate:
                return "공휴일 업데이트"
            case .firstWeekday:
                return "시작 요일"
            case .version:
                return "버전 정보"
            case .kakaoLogin:
                return "카카오 로그인"
            case .theme:
                return "테마 색상"
            }
        }
        
        enum FirstWeekday {
            static let sunday = "1"
            static let monday = "2"
            
            static func title(_ value: String) -> String {
                switch value {
                case sunday:
                    return "일요일"
                case monday:
                    return "월요일"
                default:
                    return ""
                }
            }
        }
    }
    
    enum Action {
        case restDayUpdateTapped
        case didTapKakaoLogin
        case viewDidload
    }
    
    enum Mutation {
        case showAlert(String)
        case loginSucces(Bool)
    }
    
    struct State {
        let settingList = SettingList.allCases
        var isLogin: Bool = false
        
        @Pulse var isShowAlert: String = ""
    }
    
    let initialState: State
    var disposeBag = DisposeBag()
    
    @Injected var saveRestDayUsecase: SaveRestUsecaseProtocol
    @Injected var fetchRestDayUsecase: FetchRestDayUsecaseProtocol
    @Injected var deleteRestDayusecase: DeleteRestDayUsecaseProtocol
    
    // 카카오 sdk
    @Injected var kakaoLoginUsecase: KakaoSDKLoginUsecaseProtocol
    
    init() {
        self.initialState = State()
    }
}

// MARK: - Mutation
extension SettingReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .restDayUpdateTapped:
            return Observable.create { [weak self] observer in
                guard let self else { return Disposables.create() }
                Task {
                    await self.deleteRestDayusecase.execute()
                    self.fetch()
                    NotificationCenterService.reloadCalendar.post()
                }
                return Disposables.create()
            }
        case .didTapKakaoLogin:
            return kakaoLoginUsecase.executeValidLogin()
                .observe(on: MainScheduler.instance)
                .map {
                    token in Mutation.loginSucces(true)
                } // 성공 시 Mutation 반환
                .catchAndReturn(Mutation.showAlert("로그인에 실패 하였습니다.")) // 에러 시 Mutation 반환
        case .viewDidload:
            return kakaoLoginUsecase.executeCheckToken()
                .flatMap { isInvalid in
                    isInvalid ? Observable.just(Mutation.loginSucces(true)) : Observable.just(Mutation.loginSucces(false))
                }
        }
    }
    
    func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var newState = state
        
        switch mutation {
        case .showAlert(let text):
            newState.isShowAlert = text
            
        case .loginSucces(let result):
            newState.isLogin = result
        }
        
        return newState
    }
}

// MARK:
extension SettingReactor {
    private func fetch() {
        for year in Date().surroundingYears() {
            for month in ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"] {
                fetchRestDayUsecase.excute(year: year, month: month)
                    .compactMap {$0}
                    .bind {
                        $0.forEach { self.saveRestDayUsecase.execute(restDay: $0) }
                        
                    }
                    .disposed(by: disposeBag)
            }
        }
        
        delay(5) {
            NotificationCenterService.reloadCalendar.post()
        }
    }
}
