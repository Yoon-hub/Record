//
//  DiaryNavigator.swift
//  App
//
//  Created by 윤제 on 1/8/25.
//

import UIKit

import Core
import Domain

protocol DiaryNavigatorProtocol: BaseNavigator {
    func toDiaryAdd()
    func toDiaryDetail(diary: Diary)
    var navigationController: UINavigationController { get set }
}

final class DiaryNavigator: DiaryNavigatorProtocol {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toDiaryAdd() {
        let diaryAddView = DiaryAddViewControllerWrapper().viewController
        navigationController.pushViewController(diaryAddView, animated: true)
    }
    
    func toDiaryDetail(diary: Diary) {
        let diaryDetailView = DiaryDetailViewControllerWrapper(diary: diary).viewController
        navigationController.pushViewController(diaryDetailView, animated: true)
    }
}
