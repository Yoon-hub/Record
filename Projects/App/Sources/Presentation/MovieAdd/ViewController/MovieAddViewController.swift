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
        bindOutput(reactor: reactor)
    }
    
    override func beforeBind() {
        makeNavigationItem()
    }
    
    override func setup() {}
    
    private func makeNavigationItem() {
        let rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func bindInput(reactor: R) {
        self.navigationItem.rightBarButtonItem?.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .map { $0.0.contentView }
            .map {
                if $0.contentTextView.text == $0.textViewPlaceHolderText {
                    return ($0.titleTextField.text, "")
                } else {
                    return ($0.titleTextField.text, $0.contentTextView.text)
                }
            }
            .map { Reactor.Action.didTapSaveButton($0.0, $0.1) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        contentView.imagePlusButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind {$0.0.openPhotoLibrary()}
            .disposed(by: disposeBag)
        
        // TextView PlaceHolder
        contentView.contentTextView.rx.didBeginEditing
            .withUnretained(self)
            .filter { $0.0.contentView.contentTextView.text == $0.0.contentView.textViewPlaceHolderText }
            .map {$0.0.contentView}
            .bind {
                $0.contentTextView.text.removeAll()
                $0.contentTextView.textColor = .black
            }
            .disposed(by: disposeBag)
        
        contentView.contentTextView.rx.didEndEditing
            .withUnretained(self)
            .filter { $0.0.contentView.contentTextView.text.isEmpty}
            .map {$0.0.contentView}
            .bind {
                $0.contentTextView.text = $0.textViewPlaceHolderText
                $0.contentTextView.textColor = .systemGray3
            }
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: R) {
        reactor.state.map { $0.imageItems }
            .bind(to: contentView.imageCollectionView.rx.items(
                cellIdentifier: ImageListCollectionViewCell.identifier,
                cellType: ImageListCollectionViewCell.self)
            ) { _, item, cell in
                cell.bind(image: item)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$showAlert)
            .skip(1)
            .withUnretained(self)
            .subscribe(on: MainScheduler.instance)
            .bind { $0.0.showAlert(title: "알림", message: $0.1) }
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