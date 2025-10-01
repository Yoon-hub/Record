//
//  MetamonReactor.swift
//  App
//
//  Created by 윤제 on 9/29/25.
//

import Foundation

import Core
import Domain

import ReactorKit

final class MetamonReactor: Reactor {
    // MARK: - Reactor
    enum Action {
        case viewDidload
        case didJump
        case didFeed
        case updateMetamon
    }
    
    enum Mutation {
        case setMetamon(Metamon)
        case showFeedMessage(String)
    }
    
    struct State {
        var metmona: Metamon?
        @Pulse var feedMessage: String = ""
    }
    
    
    
    let initialState: State
    
    /// 메타몬 기본 대사 배열
    let dialogues = [
        "안녕! 나는 메타몽이야 😀",
        "오늘도 힘내 공쥬! 😘",
        "귀여워! 🤓",
        "양재은 바부 😝",
        "보고싶지만 참을게.. 🥲",
        "사랑해 많이❤️",
        "오늘은 모하는감? 🐰",
        "잘자 공쥬 🌙",
        "양재은 없어서 심심해 🫠",
        "목소리 듣고 싶다 📞",
        "말차 싫어 🙅",
        "민트 싫어 😩",
        "양재은 좋아 😘",
        "밥은 챙겨 먹었는가! 🍙",
        "네가 기댈 수 있는 사람이 되고 싶어"
    ]
    
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    @Injected var fetchMetamonUsecase: FetchMetamonUsecaseProtocol
    @Injected var saveMetamonUsecase: SaveMetamonUsecaseProtocol
    @Injected var updateMetamonUsecase: UpdateMetamonUsecaseProtocol
}

extension MetamonReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidload:
            return Observable.create { [weak self] observer in
                guard let self else { return Disposables.create() }
                Task {
                    let metamon = await self.fetchMetamonUsecase.execute().first
                    
                    // 메타몽 불러오기 or 신규 생성
                    if let metamon {
                        observer.onNext(.setMetamon(metamon))
                    } else {
                        let newMetamon = Metamon(metamonItem: .basic, point: 0)
                        await self.saveMetamonUsecase.execute(metamon: newMetamon)
                        observer.onNext(.setMetamon(newMetamon))
                    }
                    observer.onCompleted()
                }
                return Disposables.create()
            }
        case .didJump:
            // SwiftData는 @Model 객체를 직접 수정하면 자동으로 저장됨
            if let metamon = self.currentState.metmona {
                metamon.point += 1
                return .just(.setMetamon(metamon))
            }
            return .empty()
        case .updateMetamon:
            if let metamon = self.currentState.metmona {
                return .just(.setMetamon(metamon))
            }
            return .empty()
            
        case .didFeed:
            guard let metamon = self.currentState.metmona else {
                return .empty()
            }
            
            // 오늘 이미 밥을 먹었는지 확인
            if !metamon.canFeedToday() {
                metamon.point -= 1
                return Observable.concat([
                    .just(.showFeedMessage("이미 배불러! 🤤 (-1P)")),
                    .just(.setMetamon(metamon))
                ])
            }
            
            // 밥 먹이기
            metamon.feed()
            return Observable.concat([
                .just(.showFeedMessage("맛있다! 배불러! 😋 (+100P)")),
                .just(.setMetamon(metamon))
            ])
        }
    }
        
    func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var newState = state
        
        switch mutation {
            
        case .setMetamon(let metamon):
            newState.metmona = metamon
            
        case .showFeedMessage(let message):
            newState.feedMessage = message
        }
        
        return newState
    }
}
