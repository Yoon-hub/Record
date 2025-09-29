//
//  MetamonView.swift
//  App
//
//  Created by 윤제 on 9/29/25.
//

import UIKit

import Core
import Design

import PinLayout
import RxSwift
import RxCocoa

final class MetamonView: UIView, BaseView {
    
    let imageView = UIImageView().then {
        $0.image = DesignAsset.metamon.image
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = true
    }
    
    let chatBox = UIImageView().then {
        $0.image = DesignAsset.metamonChatBox.image
        $0.contentMode = .scaleToFill
    }
    
    var closeButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .light)
        $0.setImage(UIImage(systemName: "xmark", withConfiguration: imageConfig), for: .normal)
        $0.tintColor = .black
    }
    
    private let speechLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.alpha = 0
    }
    
    let tapGesture = UITapGestureRecognizer()
    private let disposeBag = DisposeBag()
    
    // 말풍선 타이머 관리
    private var speechTimer: Timer?
    
    // 메타몬 기본 대사 배열
    private let dialogues = [
        "안녕! 나는 메타몽이야 😀",
        "오늘도 힘내 공쥬! 😘",
        "귀여워! 🤓",
        "양재은 바부 😝",
        "보고싶지만 참을게.. 🥲",
        "사랑해 많이❤️",
        "오늘은 모하는감? 🐰",
        "잘자 공쥬 🌙",
        "양재은 없어서 심심해 🫠",
        "목소리 듣고 싶다 📞",
        "말차 싫어 🙅",
        "민트 싫어 😩",
        "양재은 좋아 😘"
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        speechTimer?.invalidate()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
    }
    
    func configure() {
        self.backgroundColor = .white
        
        [imageView, chatBox, closeButton, speechLabel].forEach {
            self.addSubview($0)
        }
        
        setupTapGesture()
    }
    
    private func setupTapGesture() {
        imageView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.handleTap()
            })
            .disposed(by: disposeBag)
    }
    
    private func handleTap() {
        // 햅틱 피드백 (진동)
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // 점프 애니메이션과 말풍선 동시 실행
        performJumpAnimation()
        showSpeechBubble()
    }
    
    private func performJumpAnimation() {
        let originalTransform = imageView.transform
        
        UIView.animateKeyframes(
            withDuration: 0.3,
            delay: 0,
            options: [.calculationModeLinear],
            animations: {
                // 위로 점프
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3) {
                    self.imageView.transform = originalTransform.translatedBy(x: 0, y: -30)
                }
                
                // 아래로 떨어짐
                UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.3) {
                    self.imageView.transform = originalTransform.translatedBy(x: 0, y: 5)
                }
                
                // 원래 위치로 복귀
                UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                    self.imageView.transform = originalTransform
                }
            },
            completion: nil
        )
    }
    
    private func showSpeechBubble() {
        // 이전 타이머가 있다면 취소
        speechTimer?.invalidate()
        speechTimer = nil
        
        while true {
            let randomDialogue = dialogues.randomElement() ?? "안녕! 나는 메타몽이야 😀"
            if speechLabel.text != randomDialogue {
                speechLabel.text = randomDialogue
                break
            }
        }
        
        // 말풍선 위치 설정
        speechLabel.pin
            .top(20)
            .left(20)
            .right(20)
            .height(50)
        
        // 말풍선 애니메이션
        UIView.animate(withDuration: 0.3, animations: {
            self.speechLabel.alpha = 1
        }) { _ in
            // 새로운 타이머 생성하여 2초 후 말풍선 사라지기
            self.speechTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                UIView.animate(withDuration: 0.3) {
                    self.speechLabel.alpha = 0
                }
                self.speechTimer = nil
            }
        }
    }
    
    func setUI() {
        imageView.pin
            .all()
    }
}
