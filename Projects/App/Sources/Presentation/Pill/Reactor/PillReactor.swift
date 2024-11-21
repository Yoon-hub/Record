//
//  PillReactor.swift
//  App
//
//  Created by 윤제 on 11/21/24.
//

import Foundation

import Core
import Domain

import ReactorKit

final class PillReactor: Reactor {
    
    enum Action {
        case addPill(String, String)
        case viewDidload
    }
    
    enum Mutation {
        case showAlert(String)
        case setPills([Pill])
    }
    
    struct State {
        @Pulse var isAlert: String = ""
        var pills: [Pill] = []
    }
    
    let initialState: State
    
    init() {
        self.initialState = State()
    }
    
    @Injected var savePillUsecase: SavePillUsecaseProtocol
    @Injected var fetchPillUsecase: FetchPillUsecaseProtocol
    @Injected var deletePillUsecase: DeletePillUsecaseProtocol
    
}

// MARK: - Mutation
extension PillReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidload:
            return Observable.create { [weak self] observer in
                guard let self else { return Disposables.create() }
                Task {

                    let pills = await self.fetchPillUsecase.execute()
                    observer.onNext(.setPills(pills))
                }
                return Disposables.create()
            }
        case .addPill(let pill, let time):
            return Observable.create { [weak self] observer in
                guard let self else { return Disposables.create() }
                
                // 시간 형식 틀리면
                if !self.isValidTimeFormat(time) {
                    observer.onNext(.showAlert("올바른 시간을 입력해 주세요."))
                    return Disposables.create()
                }
                
                Task {
                    let pill = Pill(title: pill, time: time, use: true)
                    await self.savePillUsecase.excecute(event: pill)
                    let pills = await self.fetchPillUsecase.execute()
                    observer.onNext(.setPills(pills))
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
        case .showAlert(let message):
            newState.isAlert = message
        case .setPills(let pills):
            newState.pills = pills
        }
        
        return newState
    }
}

// MARK: -
extension PillReactor {
    private func isValidTimeFormat(_ time: String) -> Bool {
        // 정규식: 네 자리 숫자, 앞 두 자리는 00~23, 뒤 두 자리는 00~59
        let timeRegex = "^(?:[01][0-9]|2[0-3])[0-5][0-9]$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", timeRegex)
        return predicate.evaluate(with: time)
    }
}
