//
//  DiaryAddViewControllerWrapper.swift
//  App
//
//  Created by 윤제 on 1/8/25.
//

import UIKit

import Domain
import Core

final class DiaryAddViewControllerWrapper: BaseWrapper {
    
    typealias R = DiaryAddReactor
    typealias V = DiaryAddViewController
    typealias C = DiaryAddView
    
    private let editingDiary: Domain.Diary?
    
    init(editingDiary: Domain.Diary? = nil) {
        self.editingDiary = editingDiary
    }
    
    // MARK: - Make
    
    func makeViewController() -> V {
        return DiaryAddViewController(contentView: view, reactor: reactor)
    }
    
    func makeReactor() -> R {
        return DiaryAddReactor(initialState: DiaryAddReactor.State(editingDiary: editingDiary))
    }
    
    func makeView() -> C {
        return DiaryAddView()
    }
}

