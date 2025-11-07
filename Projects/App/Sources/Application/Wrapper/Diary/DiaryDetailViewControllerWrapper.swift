//
//  DiaryDetailViewControllerWrapper.swift
//  App
//
//  Created by 윤제 on 1/13/25.
//

import UIKit

import Core
import Domain

final class DiaryDetailViewControllerWrapper: BaseWrapper {
    
    typealias R = DiaryDetailReactor
    typealias V = DiaryDetailViewController
    typealias C = DiaryDetailView
    
    private let diary: Diary
    
    init(diary: Diary) {
        self.diary = diary
    }
    
    // MARK: - Make
    
    func makeViewController() -> V {
        return DiaryDetailViewController(contentView: view, reactor: reactor)
    }
    
    func makeReactor() -> R {
        return DiaryDetailReactor(initialState: DiaryDetailReactor.State(), diary: diary)
    }
    
    func makeView() -> C {
        return DiaryDetailView()
    }
}

