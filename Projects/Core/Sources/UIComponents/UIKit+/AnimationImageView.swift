//
//  AnimationImageView.swift
//  Core
//
//  Created by 윤제 on 1/15/25.
//

import UIKit

/// 이모티콘 이미지 선택 시 위아래 움직이는 에니메이션
final public class AnimationImageView: UIImageView {
    
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
    }
}
