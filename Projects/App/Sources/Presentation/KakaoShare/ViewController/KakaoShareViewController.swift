//
//  KakaoShareViewController.swift
//  App
//
//  Created by 윤제 on 1/15/25.
//

import UIKit

import Core
import Domain

import RxSwift
import FloatingBottomSheet

final class KakaoShareViewController: BaseViewController<KakaoShareReactor, KakaoShareView> {
    
    @Injected var globarProvider: GlobalStateProvider
    
    override func bind(reactor: KakaoShareReactor) {
        super.bind(reactor: reactor)
        
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
}


// MARK: - Bind
extension KakaoShareViewController {
    
    private func bindInput(reactor: KakaoShareReactor) {
        contentView.addButton.rx.tap
            .map { Reactor.Action.didTapSave }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: KakaoShareReactor) {
        reactor.state.map { $0.kakaoEvent }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { (vc, event) in
                vc.drawEvent(event)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isSaveEvent)
            .observe(on: MainScheduler.instance)
            .skip(1)
            .withUnretained(self)
            .bind { vc, _ in
                vc.globarProvider.sendEvent(.calednarEventUpdate)
                vc.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension KakaoShareViewController {
    private func drawEvent(_ event: CalendarEvent) {
        contentView.titleLabel.text = event.title
        contentView.alarmLabel.text = "알림: \(event.alarm ?? "알림 없음")"
        contentView.dateLabel.text = "\(event.startDate.formattedDateString(type: .yearMonthDayTime2)) ~ \(event.endDate.formattedDateString(type: .yearMonthDayTime2))"
        contentView.contentLabel.text = event.content
        
        contentView.titleLabel.backgroundColor = event.tagColor.toUIColor()?.withAlphaComponent(0.15)
        contentView.verticalVar.backgroundColor = event.tagColor.toUIColor()
        contentView.addButton.backgroundColor = event.tagColor.toUIColor()
        
        contentView.setNeedsLayout()
    }
}

// MARK: - FloatingBottomSheet
extension KakaoShareViewController: FloatingBottomSheetPresentable {
    var bottomSheetScrollable: UIScrollView? { UIScrollView() }
    
    var allowsDrag: Bool { false }
      
    var bottomSheetHeight: CGFloat { 440 }
}
