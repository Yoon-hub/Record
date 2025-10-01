//
//  MetamonViewController.swift
//  App
//
//  Created by 윤제 on 9/29/25.
//

import UIKit

import Core
import Design

import ReactorKit
import RxSwift
import RxCocoa

final class MetamonViewController: BaseViewController<MetamonReactor, MetamonView> {
    
    @Navigator var navigator: CalendarNavigatorProtocol
    
    /// 메타몽 이미지 탭 제스쳐
    let tapGesture = UITapGestureRecognizer()
    
    /// 메타몽 이미지 드래그 제스쳐
    let panGesture = UIPanGestureRecognizer()
    
    /// 드래그 시작 시 메타몽 위치
    private var initialMetamonCenter: CGPoint = .zero
    
    /// 원래 메타몽 위치 (중앙)
    private var originalMetamonCenter: CGPoint = .zero
    
    /// 드래그 진동 피드백
    private let dragFeedback = UIImpactFeedbackGenerator(style: .light)
    
    override func bind(reactor: MetamonReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reactor?.action.onNext(.viewDidload)
        
        // 진동 피드백 준비
        dragFeedback.prepare()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 원래 위치 저장 (중앙)
        if originalMetamonCenter == .zero {
            originalMetamonCenter = contentView.metamonContainer.center
        }
    }
}

extension MetamonViewController {
    
    private func bindInput(reactor: MetamonReactor) {
        
        // 탭 제스쳐 추가
        contentView.metamonContainer.addGestureRecognizer(tapGesture)
        
        // 드래그 제스쳐 추가
        contentView.metamonContainer.addGestureRecognizer(panGesture)
        
        // 탭과 드래그가 동시에 인식되도록 설정
        tapGesture.require(toFail: panGesture)
        
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.handleTap()
            })
            .disposed(by: disposeBag)
        
        panGesture.rx.event
            .subscribe(onNext: { [weak self] gesture in
                self?.handlePan(gesture)
            })
            .disposed(by: disposeBag)
        
        contentView.shoppingButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                let completion = { self.reactor!.action.onNext(.updateMetamon) }
                self.navigator.toMetamonStore(self, handler: completion)
            })
            .disposed(by: disposeBag)
        
        // 밥 주기 버튼
        contentView.feedButton.rx.tap
            .map { Reactor.Action.didFeed }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        contentView.feedButton.rx.tap
            .bind {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                
                self.performJumpAnimation(false)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: MetamonReactor) {
        // 메타몬 상태 업데이트
        reactor.state
            .map { $0.metmona }
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, metamon in
                vc.contentView.imageView.image = metamon.metamonItem.metamonImage ?? DesignAsset.metamon.image
                let pointString = metamon.point.addComma()
                vc.contentView.pointLabel.text = "POINT: \(pointString)"
                
                // 텍스트 변경 후 즉시 레이아웃 재계산
                vc.contentView.setNeedsLayout()
            })
            .disposed(by: disposeBag)
        
        // 밥 주기 메시지
        reactor.pulse(\.$feedMessage)
            .filter { !$0.isEmpty }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, message in
                vc.showFeedMessage(message)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Handle Gestures
extension MetamonViewController {
    
    /// 드래그 핸들러
    private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: contentView)
        
        switch gesture.state {
        case .began:
            // 드래그 시작 시 현재 위치 저장
            initialMetamonCenter = contentView.metamonContainer.center
            
            // 시작 시 한 번 진동
            dragFeedback.impactOccurred(intensity: 0.5)
            
            // 약간 커지는 애니메이션 (들어올리는 느낌)
            UIView.animate(withDuration: 0.2) {
                self.contentView.metamonContainer.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
            
        case .changed:
            // 손가락 위치에 따라 메타몽 이동
            let newCenter = CGPoint(
                x: initialMetamonCenter.x + translation.x,
                y: initialMetamonCenter.y + translation.y
            )
            contentView.metamonContainer.center = newCenter
            
            // 이동 중 주기적으로 미세한 진동 (거리에 따라)
            let distance = sqrt(translation.x * translation.x + translation.y * translation.y)
            if Int(distance) % 30 == 0 {  // 30pt마다 진동
                dragFeedback.impactOccurred(intensity: 0.3)
            }
            
        case .ended, .cancelled:
            // 원래 자리로 돌아가는 애니메이션
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.6,
                    initialSpringVelocity: 0.8,
                options: .curveEaseOut
            ) {
                self.contentView.metamonContainer.center = self.originalMetamonCenter
                self.contentView.metamonContainer.transform = .identity  // 원래 크기로
            } completion: { _ in
                // 도착 시 진동
                self.dragFeedback.impactOccurred(intensity: 0.7)
            }
            
        default:
            break
        }
    }
    
    /// 탭 핸들러
    private func handleTap() {
        // 햅틱 피드백 (진동)
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // 점프 애니메이션과 말풍선 동시 실행
        performJumpAnimation()
        showSpeechBubble()
        
        // 이모티콘 효과 실행
        showEmoticonEffect()
    }
    
    private func performJumpAnimation(_ point: Bool = true) {
        let originalTransform = contentView.metamonContainer.transform
        
        UIView.animateKeyframes(
            withDuration: 0.3,
            delay: 0,
            options: [.calculationModeLinear],
            animations: {
                // 위로 점프
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3) {
                    self.contentView.metamonContainer.transform = originalTransform.translatedBy(x: 0, y: -30)
                }
                
                // 아래로 떨어짐
                UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.3) {
                    self.contentView.metamonContainer.transform = originalTransform.translatedBy(x: 0, y: 5)
                }
                
                // 원래 위치로 복귀
                UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                    self.contentView.metamonContainer.transform = originalTransform
                }
            }) { _ in
                if point { self.reactor?.action.onNext(.didJump) }
            }
    }
    
    
    private func showSpeechBubble() {
        // 이전 타이머가 있다면 취소
        contentView.speechTimer?.invalidate()
        contentView.speechTimer = nil
        
        // 랜덤 대사 선택
        let randomDialogue = reactor?.dialogues.randomElement() ?? "안녕!"
        contentView.speechLabel.text = randomDialogue
        
        // 말풍선 위치 설정
        contentView.speechLabel.pin
            .top(20)
            .left(20)
            .right(20)
            .height(50)
        
        // 말풍선 애니메이션
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.speechLabel.alpha = 1
        }) { _ in
            // 새로운 타이머 생성하여 2초 후 말풍선 사라지기
            self.contentView.speechTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                UIView.animate(withDuration: 0.3) {
                    self.contentView.speechLabel.alpha = 0
                }
                self.contentView.speechTimer = nil
            }
        }
    }

    /// 밥 주기 메시지 표시
    private func showFeedMessage(_ message: String) {
        // 말풍선으로 메시지 표시
        contentView.speechTimer?.invalidate()
        contentView.speechTimer = nil
        
        contentView.speechLabel.text = message
        
        // 말풍선 위치 설정
        contentView.speechLabel.pin
            .top(20)
            .left(20)
            .right(20)
            .height(50)
        
        // 말풍선 애니메이션
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.speechLabel.alpha = 1
        }) { _ in
            // 2초 후 말풍선 사라지기
            self.contentView.speechTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                UIView.animate(withDuration: 0.3) {
                    self.contentView.speechLabel.alpha = 0
                }
                self.contentView.speechTimer = nil
            }
        }
    }
    

    
    private func showEmoticonEffect() {
        // 랜덤 이모티콘 선택
        guard let emoticonImage = EmoticonProvider.randomEmoticon() else { return }
        
        // 이모티콘 이미지뷰 생성
        let emoticonImageView = UIImageView(image: emoticonImage)
        emoticonImageView.contentMode = .scaleAspectFit
        
        let randomSize = CGFloat.random(in: 60...100)
        
        emoticonImageView.frame = CGRect(x: 0, y: 0, width: randomSize, height: randomSize)
        
        // 랜덤 위치 설정 (화면 전체에서 랜덤)
        let randomX = CGFloat.random(in: 50...(self.contentView.bounds.width - 90))
        let randomY = CGFloat.random(in: 50...(self.contentView.bounds.height - 90))
        emoticonImageView.center = CGPoint(x: randomX, y: randomY)
        
        // 초기 상태 설정
        emoticonImageView.alpha = 0
        emoticonImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        // 뷰에 추가
        self.contentView.addSubview(emoticonImageView)
        
        // 애니메이션 실행
        UIView.animateKeyframes(
            withDuration: 1.5,
            delay: 0,
            options: [.calculationModeLinear],
            animations: {
                // 나타나기 (0.2초)
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.13) {
                    emoticonImageView.alpha = 1
                    emoticonImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }
                
                // 정상 크기로 (0.1초)
                UIView.addKeyframe(withRelativeStartTime: 0.13, relativeDuration: 0.07) {
                    emoticonImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
                
                // 위로 떠오르기 (0.5초)
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.33) {
                    emoticonImageView.center.y -= 30
                }
                
                // 사라지기 (0.8초)
                UIView.addKeyframe(withRelativeStartTime: 0.53, relativeDuration: 0.47) {
                    emoticonImageView.alpha = 0
                    emoticonImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }
            },
            completion: { _ in
                // 애니메이션 완료 후 뷰에서 제거
                emoticonImageView.removeFromSuperview()
            }
        )
    }
    
}
