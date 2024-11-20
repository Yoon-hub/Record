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
        case pillAlarm
        
        var title: String {
            switch self {
            case .restDayUpdate:
                return "공휴일 업데이트"
            case .pillAlarm:
                return "알약 알리미"
            }
        }
    }
    
    enum Action {
        case restDayUpdateTapped
    }
    
    enum Mutation {
        
    }
    
    struct State {
        let settingList = SettingList.allCases
    }
    
    let initialState: State
    var disposeBag = DisposeBag()
    
    @Injected var saveRestDayUsecase: SaveRestUsecaseProtocol
    @Injected var fetchRestDayUsecase: FetchRestDayUsecaseProtocol
    @Injected var deleteRestDayusecase: DeleteRestDayUsecaseProtocol
    
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
        }
    }
    
    func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var newState = state
        
        switch mutation {
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            NotificationCenterService.reloadCalendar.post()
        }
    }
}
