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
        
        // 이모티콘 효과 실행
        showEmoticonEffect()
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
        
        // 랜덤 대사 선택
        let randomDialogue = dialogues.randomElement() ?? "안녕!"
        speechLabel.text = randomDialogue
        
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
            self.speechTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                UIView.animate(withDuration: 0.3) {
                    self.speechLabel.alpha = 0
                }
                self.speechTimer = nil
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
        let randomX = CGFloat.random(in: 50...(self.bounds.width - 90))
        let randomY = CGFloat.random(in: 50...(self.bounds.height - 90))
        emoticonImageView.center = CGPoint(x: randomX, y: randomY)
        
        // 초기 상태 설정
        emoticonImageView.alpha = 0
        emoticonImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        // 뷰에 추가
        self.addSubview(emoticonImageView)
        
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
    
    func setUI() {
        imageView.pin
            .all()
    }
}
