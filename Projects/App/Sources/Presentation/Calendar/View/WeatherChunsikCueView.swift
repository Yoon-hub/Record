//
//  WeatherChunsikCueView.swift
//  App
//

import UIKit

import Core

final class WeatherChunsikCueView: UIView {
    /// systemGray6/5보다 한 톤 옅게 (불투명)
    private enum Chrome {
        static let fill = UIColor { tc in
            switch tc.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.15, green: 0.15, blue: 0.16, alpha: 1)
            default:
                return UIColor(red: 0.976, green: 0.976, blue: 0.98, alpha: 1)
            }
        }
        static let border = UIColor { tc in
            switch tc.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 1)
            default:
                return UIColor(red: 0.91, green: 0.91, blue: 0.93, alpha: 1)
            }
        }
    }
    
    private let characterBackdropCanReceiveTouches: Bool
    private weak var tappableCharacterBackdrop: UIView?
    private var onCharacterImageTap: (() -> Void)?
    
    init(
        summary: TodayWeatherSummaryService.WeatherDaySummary,
        characterImage: UIImage,
        characterImageTapEnabled: Bool,
        onCharacterImageTap: (() -> Void)?
    ) {
        self.characterBackdropCanReceiveTouches = characterImageTapEnabled && onCharacterImageTap != nil
        self.onCharacterImageTap = onCharacterImageTap
        super.init(frame: .zero)
        
        let bubbleLabel = UILabel().then {
            $0.text = summary.fullLine
            $0.font = .systemFont(ofSize: 15, weight: .medium)
            $0.textColor = .label
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        installBubbleAndCharacter(
            bubbleContent: bubbleLabel,
            characterImage: characterImage,
            enableCharacterBackdropTap: characterBackdropCanReceiveTouches
        )
    }
    
    init(plainMessage: String, characterImage: UIImage) {
        self.characterBackdropCanReceiveTouches = false
        self.onCharacterImageTap = nil
        super.init(frame: .zero)
        
        let bubbleLabel = UILabel().then {
            $0.text = plainMessage
            $0.font = .systemFont(ofSize: 15, weight: .medium)
            $0.textColor = .label
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        installBubbleAndCharacter(
            bubbleContent: bubbleLabel,
            characterImage: characterImage,
            enableCharacterBackdropTap: false
        )
    }
    
    private func installBubbleAndCharacter(
        bubbleContent: UIView,
        characterImage: UIImage,
        enableCharacterBackdropTap: Bool
    ) {
        let bubbleWrap = UIView().then {
            $0.backgroundColor = Chrome.fill
            $0.layer.cornerRadius = 14
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = Chrome.border.cgColor
        }
        
        let characterImageView = UIImageView().then {
            $0.image = characterImage
            $0.contentMode = .scaleAspectFit
        }
        
        let imageBackdrop = UIView().then {
            $0.backgroundColor = Chrome.fill
            $0.layer.cornerRadius = 18
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = Chrome.border.cgColor
        }
        imageBackdrop.addSubview(characterImageView)
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        if enableCharacterBackdropTap {
            imageBackdrop.isUserInteractionEnabled = true
            tappableCharacterBackdrop = imageBackdrop
            imageBackdrop.accessibilityLabel = "내일 날씨 보기"
            imageBackdrop.accessibilityTraits.insert(.button)
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCharacterBackdrop))
            imageBackdrop.addGestureRecognizer(tap)
        } else {
            imageBackdrop.isUserInteractionEnabled = false
        }
        
        bubbleWrap.addSubview(bubbleContent)
        bubbleContent.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView(arrangedSubviews: [bubbleWrap, imageBackdrop]).then {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 8
        }
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            bubbleContent.topAnchor.constraint(equalTo: bubbleWrap.topAnchor, constant: 10),
            bubbleContent.leadingAnchor.constraint(equalTo: bubbleWrap.leadingAnchor, constant: 12),
            bubbleContent.trailingAnchor.constraint(equalTo: bubbleWrap.trailingAnchor, constant: -12),
            bubbleContent.bottomAnchor.constraint(equalTo: bubbleWrap.bottomAnchor, constant: -10),
            
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            characterImageView.topAnchor.constraint(equalTo: imageBackdrop.topAnchor, constant: 8),
            characterImageView.leadingAnchor.constraint(equalTo: imageBackdrop.leadingAnchor, constant: 10),
            characterImageView.trailingAnchor.constraint(equalTo: imageBackdrop.trailingAnchor, constant: -10),
            characterImageView.bottomAnchor.constraint(equalTo: imageBackdrop.bottomAnchor, constant: -8),
            characterImageView.heightAnchor.constraint(equalToConstant: 96),
            characterImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 136)
        ])
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard characterBackdropCanReceiveTouches,
              let hit = super.hitTest(point, with: event),
              let backdrop = tappableCharacterBackdrop,
              hit === backdrop || hit.isDescendant(of: backdrop)
        else { return nil }
        return hit
    }
    
    @objc private func didTapCharacterBackdrop() {
        onCharacterImageTap?()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
