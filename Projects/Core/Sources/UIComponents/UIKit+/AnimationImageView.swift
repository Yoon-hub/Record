//
//  AnimationImageView.swift
//  Core
//
//  Created by 윤제 on 1/15/25.
//

import UIKit

import Design

/// 이모티콘 이미지 선택 시 위아래 움직이는 애니메이션
final public class AnimationImageView: UIImageView {
    
    // 누른 횟수를 저장할 변수
    private var tapCount = 0
    private let maxTaps = 10 // 최대 탭 횟수
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGesture()
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        // 진동
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
        
        // 애니메이션 처리
        let originalPosition = self.center
        UIView.animate(withDuration: 0.1, animations: {
            // 위로 이동
            self.center.y -= 15
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                // 원래 위치로 복귀
                self.center = originalPosition
            })
        }
        
        // 누른 횟수 증가 및 확인
        tapCount += 1
        if tapCount >= maxTaps {
            // 10번 이상 클릭 시 숨김 처리
            UIView.animate(withDuration: 1, animations: {
                // 위로 이동
                self.image = DesignAsset.boom.image
            }) { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    // 원래 위치로 복귀
                    self.isHidden = true
                })
            }
            
        }
    }
}
