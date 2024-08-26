//
//  AppDelegate.swift
//  App
//
//  Created by 윤제 on 7/8/24.
//

import UIKit

import Core
import Domain
import Data
import Design

import RxSwift
import RxCocoa

@main
 class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let disposebag = DisposeBag()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let containers: [BaseContainer] = [
            MovieDIContainer(),
            RestDayDIContrainer(),
            EventDIContainer()
        ]
        containers.forEach {
            $0.registerDependencies()
        }
        
        fetchRestDay()
        
        return true
    }
}

extension AppDelegate {
    
    /// 최초 실행 시 공휴일 데이터 받아오는 메서드
    func fetchRestDay() {
        
        @UserDefault(key: "isFetchRestDay")
        var isFetchRestDay: String
        
        if isFetchRestDay == "Y" { return }
        
        @Injected var saveRestDayUsecase: SaveRestUsecaseProtocol
        @Injected var fetchRestDayUsecase: FetchRestDayUsecaseProtocol
        
        for year in Date().surroundingYears() {
            for month in ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"] {
                fetchRestDayUsecase.excute(year: year, month: month)
                    .compactMap {$0}
                    .bind {
                        $0.forEach { saveRestDayUsecase.execute(restDay: $0) }
                        isFetchRestDay = "Y"
                    }
                    .disposed(by: disposebag)
            }
        }
    }
}
