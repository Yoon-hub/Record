//
//  MetamonStoreReactor.swift
//  App
//
//  Created by 윤제 on 10/1/25.
//

import Foundation

import Core
import Domain
import Domain

import ReactorKit

final class MetamonStoreReactor: Reactor {
    // MARK: - Reactor
    enum Action {
        case viewDidload
        case itemSelected(MetamonItem)
        case itemBuy(MetamonItem)
    }
    
    enum Mutation {
        case setMetamon(Metamon)
    }
    
    struct State {
        
        /// 메타몽 총 아이템 리스트
        var metamonItemList: [MetamonItem] { MetamonItem.allCases }
        
        /// 메타몽
        var metmona: Metamon?
        
        /// 보유중인 메타봉 아이템
        var ownedMetamonItem: [MetamonItem] {
            let itemListString = UserDefaultsWrapper.itemList
            
            var itemList: [MetamonItem] = []
            
            itemListString.forEach { itemString in
                if let item = MetamonItem(rawValue: itemString) {
                    itemList.append(item)
                }
            }
            return itemList
        }
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }

    @Injected var fetchMetamonUsecase: FetchMetamonUsecaseProtocol
}

extension MetamonStoreReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidload:
            return Observable.create { [weak self] observer in
                guard let self else { return Disposables.create() }
                Task {
                    guard let metamon = await self.fetchMetamonUsecase.execute().first else { return }
                    observer.onNext(.setMetamon(metamon))
                }
                return Disposables.create()
            }
        case .itemSelected(let metamonItem):
            currentState.metmona?.metamonItem = metamonItem
            return .just(.setMetamon(currentState.metmona!) )
        case .itemBuy(let metamonItem):
            currentState.metmona?.metamonItem = metamonItem
            currentState.metmona?.point -= metamonItem.price
            
            var itemList = UserDefaultsWrapper.itemList
            itemList.append(metamonItem.rawValue)
            UserDefaultsWrapper.itemList = itemList
            
            return .just(.setMetamon(currentState.metmona!) )
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
        }
        
        return newState
    }
}

