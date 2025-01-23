//
//  CustomPopView.swift
//  Core
//
//  Created by 윤제 on 8/21/24.
//

import UIKit

import PinLayout
import Design

public class CustomPopView: UIView {
    
    private enum Metric {
        static let cornerRadius = 14.0
        static let contentViewInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
        static let sampleLabelTopSpacing = 120.0
        static let bottomLeftBottomRightCornerMask: CACornerMask = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    private enum Color {
        static let white = UIColor.white
        static let dimmedBlack = UIColor.black.withAlphaComponent(0.25)
        static let clear = UIColor.clear
    }
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    public lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.white
        view.layer.cornerRadius = Metric.cornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    private var completeButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = Theme.theme
        $0.setTitleColor(.white, for: .normal)
    }
    
    //  SheetView.swift
    public func show(_ perentView: UIViewController, completion: (() -> Void)? = nil) {
        
        DispatchQueue.main.async {
            perentView.view.addSubview(self)
            self.addSubview(self.backgroundView)
            self.addSubview(self.contentView)
            
            self.pin
                .all()
            
            self.backgroundView.pin
                .all()
            
            self.contentView.pin
                .center()
                .width(300)
                .height(300)
                
        
            self.backgroundView.backgroundColor = Color.dimmedBlack
            self.layoutIfNeeded()
            
        }
    }
    
    public func hide(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            UIView.animate(
                withDuration: 0,
                delay: 0,
                options: .allowAnimatedContent,
                animations: {
                    self.backgroundView.backgroundColor = Color.clear
                    self.layoutIfNeeded()
                },
                completion: { _ in
                    completion?()
                    self.removeFromSuperview()
                }
            )
        }
    }
}
