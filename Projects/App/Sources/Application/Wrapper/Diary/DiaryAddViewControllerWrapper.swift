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
    private let selectedDate: Date?
    
    init(editingDiary: Domain.Diary? = nil, selectedDate: Date? = nil) {
        self.editingDiary = editingDiary
        self.selectedDate = selectedDate
    }
    
    // MARK: - Make
    
    func makeViewController() -> V {
        return DiaryAddViewController(contentView: view, reactor: reactor)
    }
    
    func makeReactor() -> R {
        return DiaryAddReactor(
            initialState: DiaryAddReactor.State(
                editingDiary: editingDiary,
                selectedDate: selectedDate
            )
        )
    }
    
    func makeView() -> C {
        return DiaryAddView()
    }
}

