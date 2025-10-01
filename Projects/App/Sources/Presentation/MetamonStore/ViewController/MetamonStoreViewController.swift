//
//  MetamonStoreViewController.swift
//  App
//
//  Created by 윤제 on 10/1/25.
//

import UIKit

import Core
import Design
import Domain

import ReactorKit
import RxSwift
import RxCocoa

final class MetamonStoreViewController: BaseViewController<MetamonStoreReactor, MetamonStoreView> {
    
    var updateMetamona: (() -> Void)?
    
    override func bind(reactor: MetamonStoreReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reactor?.action.onNext(.viewDidload)
    }
}

extension MetamonStoreViewController {
    
    private func bindInput(reactor: MetamonStoreReactor) {
        contentView.closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: MetamonStoreReactor) {
        reactor.state.map { $0.metamonItemList }
            .bind(to: contentView.collectionView.rx.items(
                cellIdentifier: MetamonStoreCell.identifier,
                cellType: MetamonStoreCell.self)
            ) { _, item, cell in
                
                let selectedItem = item == reactor.currentState.metmona?.metamonItem
                let ownedItem = reactor.currentState.ownedMetamonItem.contains(item)
                
                cell.bind(
                    item,
                    selectedItem: selectedItem,
                    owenItem: ownedItem
                )
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.metmona }
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] metmona in
                self?.contentView.pointLabel.text = "POINT: \(metmona.point.addComma())"
                self?.contentView.collectionView.reloadData()
                self?.updateMetamona?()
            })
            .disposed(by: disposeBag)
        
        /// 아이템 선택 이벤트
        contentView.collectionView.rx.itemSelected
            .withUnretained(self)
            .bind {
                let item = reactor.currentState.metamonItemList[$0.1.row]
                
                if reactor.currentState.ownedMetamonItem.contains(item) {
                    // 장착 아이템 변경
                    reactor.action.onNext(.itemSelected(item))
                } else {
                    
                    // 미보유 아이템
                    $0.0.buyItem(item)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension MetamonStoreViewController {
    
    private func buyItem(_ item: MetamonItem) {
        showAlert(title: "구매하시겠습니까?", message: "참고로 환불은 안돼 공쥬🤓", cancel: true) {
            
            if self.reactor!.currentState.metmona!.point < item.price {
                self.showAlert(title: "포인트가 부족해 🥲", message: "메타몽을 열심히 탭해서 포인트를 모아봐!")
            } else {
                // 구매 처리
                self.reactor?.action.onNext(.itemBuy(item))
            }
        }
    }
}
