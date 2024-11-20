//
//  SettingVReactor.swift
//  App
//
//  Created by 윤제 on 11/19/24.
//

import Foundation

import Core

import ReactorKit

final class SettingReactor: Reactor {
    
    enum Action {
        case viewDidLoad
    }
    
    enum Mutation {
        
    }
    
    struct State {
        let settingList = ["공휴일 업데이트", "알약 알리미"]
    }

    let initialState: State
    
    init() {
        self.initialState = State()
    }
}
