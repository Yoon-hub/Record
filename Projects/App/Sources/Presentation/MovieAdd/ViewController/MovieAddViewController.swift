//
//  MovieAddViewController.swift
//  App
//
//  Created by 윤제 on 7/16/24.
//

import UIKit

import Core

import ReactorKit
import RxSwift
import RxCocoa

final class MovieAddViewController: BaseViewController<MovieAddReactor, MovieAddView> {
    override func setup() {
        view.backgroundColor = .purple
    }
}
