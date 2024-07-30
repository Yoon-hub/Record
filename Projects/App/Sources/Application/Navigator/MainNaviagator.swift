//
//  MainNaviagator.swift
//  App
//
//  Created by 윤제 on 7/16/24.
//

import UIKit

import Core

protocol MainNaviagatorProtocol: BaseNavigator {
    func toMovieAdd()
    func popToMain()
}

final class MainNaviagator: MainNaviagatorProtocol {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toMovieAdd() {
        let movieAddView = MovieAddViewControllerWrapper().viewController
        self.navigationController.pushViewController(movieAddView, animated: true)
    }
    
    func popToMain() {
        self.navigationController.popViewController(animated: true)
    }
}
