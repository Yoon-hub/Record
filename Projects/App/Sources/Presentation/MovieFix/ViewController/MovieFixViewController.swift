//
//  MovieFixViewController.swift
//  App
//
//  Created by 윤제 on 8/9/24.
//

import UIKit
import PhotosUI

import Core
import Design

import ReactorKit
import RxSwift
import RxCocoa

final class MovieFixViewController: BaseViewController<MovieFixReactor, MovieAddView> {
    
    typealias R = MovieFixReactor
    
    @Navigator var navigator: MainNaviagatorProtocol
    
    var completion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reactor?.action.onNext(.viewDidLoad)
    }
    
    override func bind(reactor: R) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func beforeBind() {
        makeNavigationItem()
    }
    
    override func setup() {
        contentView.datePicker.layer.opacity = 0.1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
   }
    
    private func makeNavigationItem() {
        let rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.title = "수정하기"
    }
    
    private func bindInput(reactor: R) {
        self.navigationItem.rightBarButtonItem?.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .map { $0.0.contentView }
            .map {
                if $0.contentTextView.text == $0.textViewPlaceHolderText { // placholder text
                    return Reactor.Action.didTapSaveButton($0.titleTextField.text, "", $0.datePicker.date)
                } else {
                    return Reactor.Action.didTapSaveButton($0.titleTextField.text, $0.contentTextView.text, $0.datePicker.date)
                }
            }
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
        
        contentView.imageCollectionView.rx.itemSelected
            .map { Reactor.Action.didTapImageCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        contentView.firstStarButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .map {Reactor.Action.didTapRateStar(1)}
            .bind (to: reactor.action)
            .disposed(by: disposeBag)
        
        contentView.secondStarButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .map {Reactor.Action.didTapRateStar(2)}
            .bind (to: reactor.action)
            .disposed(by: disposeBag)
        
        contentView.thirdStarButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .map {Reactor.Action.didTapRateStar(3)}
            .bind (to: reactor.action)
            .disposed(by: disposeBag)
        
        contentView.fourthStarButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .map {Reactor.Action.didTapRateStar(4)}
            .bind (to: reactor.action)
            .disposed(by: disposeBag)
        
        contentView.fifthStarButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .map {Reactor.Action.didTapRateStar(5)}
            .bind (to: reactor.action)
            .disposed(by: disposeBag)
        
        contentView.datePicker.rx.date
            .map { $0.formattedDateString() }
            .withUnretained(self)
            .bind { $0.0.contentView.dateLabel.text = $0.1 }
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: R) {
        reactor.state.map { $0.imageItems }
            .bind(to: contentView.imageCollectionView.rx.items(
                cellIdentifier: MovieAddCollectionViewCell.identifier,
                cellType: MovieAddCollectionViewCell.self)
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
        
        reactor.pulse(\.$isSaveSucess)
            .withUnretained(self)
            .subscribe(on: MainScheduler.instance)
            .filter { $0.1 }
            .bind { (vc, _) in
                vc.showAlert(title: "알림", message: "저장이 완료되었습니다.") {
                    vc.completion?()
                    vc.navigator.pop()
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.rate }
            .withUnretained(self)
            .subscribe(on: MainScheduler.instance)
            .bind { $0.0.changeStar($0.1)}
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isSettingMovie)
            .withUnretained(self)
            .map { $0.0.contentView }
            .bind {
                $0.titleTextField.text = reactor.currentState.movie.title
                $0.contentTextView.text = reactor.currentState.movie.content
                $0.datePicker.date = reactor.currentState.movie.date
                $0.dateLabel.text = reactor.currentState.movie.date.formattedDateString()
                $0.contentTextView.textColor = .black
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Gallery
extension MovieFixViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        for result in results {
            result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { (url, error) in
                guard let url = url else {
                    print("Error loading file representation: \(String(describing: error))")
                    return
                }
                
                do {
                    let data = try Data(contentsOf: url)
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.reactor?.action.onNext(.addImage(image))
                        }
                    }
                } catch {
                    print("Error loading image data: \(error.localizedDescription)")
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

// MARK: - User Define
extension MovieFixViewController {
    private func changeStar(_ rate: Int) {
        let starButtons = [contentView.firstStarButton, contentView.secondStarButton, contentView.thirdStarButton, contentView.fourthStarButton, contentView.fifthStarButton]
        for i in 0..<rate {
            starButtons[i].setImage(DesignAsset.starFill.image, for: .normal)
        }
        
        for i in rate..<5 {
            starButtons[i].setImage(DesignAsset.star.image, for: .normal)
        }
    }

}

