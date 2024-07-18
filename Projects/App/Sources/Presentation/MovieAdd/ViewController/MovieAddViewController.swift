//
//  MovieAddViewController.swift
//  App
//
//  Created by 윤제 on 7/16/24.
//

import UIKit
import PhotosUI

import Core

import ReactorKit
import RxSwift
import RxCocoa

final class MovieAddViewController: BaseViewController<MovieAddReactor, MovieAddView> {
    
    typealias R = MovieAddReactor
    
    override func bind(reactor: R) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
    }
    
    override func setup() {
        
    }
    
    private func bindInput(reactor: R) {
        contentView.imagePlusButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind {$0.0.openPhotoLibrary()}
            .disposed(by: disposeBag)
    }
}

// MARK: - Gallery
extension MovieAddViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self?.reactor?.action.onNext(.addImage(image))
                        }
                    }
                }
            }
        }
    }
    
    func openPhotoLibrary() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 7
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
}
