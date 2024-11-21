//
//  PillViewController.swift
//  App
//
//  Created by 윤제 on 11/21/24.
//

import UIKit

import Core
import RxSwift
import RxCocoa

import FloatingBottomSheet

final class PillViewController: BaseViewController<PillReactor, PillView> {
    
    let customPopView = CustomPopView()
    
    override func viewDidLoad() {
        contentView.tableView.delegate = self
        reactor?.action.onNext(.viewDidload)
    }
    
    override func bind(reactor: PillReactor) {
        bindInput(reactor)
        bindOutput(reactor)
    }
}

//MARK: - Bind
extension PillViewController {
    private func bindInput(_ reactor: PillReactor) {
        contentView.addButton.rx.tap
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind {
                $0.0.showPillAddAlert()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(_ reactor: PillReactor) {
        
        reactor.state.map { $0.pills }
            .bind(to: contentView.tableView.rx.items(cellIdentifier: PillTableViewCell.identifier, cellType: PillTableViewCell.self)
            ) { [weak self] _, item, cell in
                cell.timeLabel.text = self?.formatTimeString(item.time)
                cell.titleLabel.text = item.title
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isAlert)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind {
                $0.0.showAlert(title: $0.1, message: nil)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - TableView
extension PillViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        guard let reactor else {return UISwipeActionsConfiguration()}
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
            //self?.reactor?.action.onNext(.didDeleteEvent(indexPath))
            completionHandler(true)
        }
        
        
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.red)
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

//MARK: -
extension PillViewController {
    private func showPillAddAlert() {
        let alert = UIAlertController(title: "정보 입력", message: "이름을 입력하세요", preferredStyle: .alert)
        
        // 텍스트 필드 추가
        alert.addTextField { textField in
            textField.placeholder = "알약"
        }
        
        alert.addTextField { textField in
            textField.keyboardType = .numberPad
            textField.placeholder = "2300"
        }
        
        // 확인 버튼 추가
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let textFields = alert.textFields else {return}
            guard let pill = textFields.first?.text, let time = textFields[1].text else { return }
            
            self?.reactor?.action.onNext(.addPill(pill, time))
        }
        
        // 취소 버튼 추가
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func formatTimeString(_ time: String) -> String? {
        guard time.count == 4, let hour = Int(time.prefix(2)), let minute = Int(time.suffix(2)) else {
            return nil // 잘못된 형식일 경우 nil 반환
        }
        
        // 시간과 분이 유효한지 확인 (00~23, 00~59)
        guard (0...23).contains(hour), (0...59).contains(minute) else {
            return nil
        }
        
        return String(format: "%02d:%02d", hour, minute)
    }
}

//MARK: - FloatingBottomSheet
extension PillViewController: FloatingBottomSheetPresentable {
    
    var bottomSheetScrollable: UIScrollView? { UIScrollView() }
    
    var allowsDrag: Bool { false }
      
    var bottomSheetHeight: CGFloat { 440 }
}

// MARK: -
