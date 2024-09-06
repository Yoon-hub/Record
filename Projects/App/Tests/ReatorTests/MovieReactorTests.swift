//
//  MovieReactorTests.swift
//  AppUnitTest
//
//  Created by 윤제 on 9/6/24.
//

import XCTest
import RxSwift
import ReactorKit

import Core
import Domain

@testable import App

final class MovieReactorTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    var reactor: MovieReactor!
    
    override func setUp() {
        super.setUp()
        
        disposeBag = DisposeBag()
        
        // Mock Usecase 주입
        Container.standard.register(type: FetchMovieUsecaseProtocol.self) { _ in FetchMovieMockUsecase() }
        
        reactor = MovieReactor(initialState: MovieReactor.State())
    }
    
    override func tearDown() {
        self.disposeBag = nil
        self.reactor = nil
        super.tearDown()
    }
    
    func test_viewDidLoad_fetchMovies() {
        // Given
         reactor.action.onNext(.viewDidLoad)
         
         // When: Reactor의 State가 업데이트 되는지 확인
         let expectation = XCTestExpectation(description: "Movies should be loaded")
        
        reactor.state
            .map { $0.movieItems }
            .distinctUntilChanged()
            .skip(1)
            .subscribe(onNext: { movies in
                XCTAssertTrue(movies.count == 2)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        // Then: expectation이 충족될 때까지 기다림
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_openNextView_didTapRightBarButtonItem() {
        // Given
        reactor.action.onNext(.openNextView(.didTapRightBarButtonItem))
        
        let expectation = XCTestExpectation(description: "Transition to addMovie")
        
        reactor.state
            .map { $0.openNextView }
            .distinctUntilChanged()
            .subscribe(onNext: { transition in
                if .addMovie == transition {
                    expectation.fulfill() // addMovie 화면으로 전환되는지 확인
                }
            })
            .disposed(by: disposeBag)
        
        // Then: expectation이 충족될 때까지 기다림
        wait(for: [expectation], timeout: 1.0)
    }
}
