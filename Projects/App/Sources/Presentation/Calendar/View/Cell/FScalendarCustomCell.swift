//
//  FScalendarCustomCell.swift
//  App
//
//  Created by 윤제 on 8/13/24.
//

import UIKit

import Core
import Design
import Domain

import FSCalendar
import PinLayout

final class FScalendarCustomCell: FSCalendarCell, BaseView {
    
    let line = UIView().then {
        $0.backgroundColor = .systemGray6
    }
    
    let firsTagLine = UIView().then {
        $0.layer.cornerRadius = 2
        $0.backgroundColor = .clear
    }
    
    let firstTitle = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 8)
        $0.textColor = .black.withAlphaComponent(0.8)
        $0.lineBreakMode = .byClipping
        $0.numberOfLines = 1
    }
    
    let secondTagLine = UIView().then {
        $0.layer.cornerRadius = 2
        $0.backgroundColor = .clear
    }
    
    let secondTitle = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 8)
        $0.textColor = .black.withAlphaComponent(0.8)
        $0.lineBreakMode = .byClipping
        $0.numberOfLines = 1
    }
    
    let plusLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 8)
        $0.textColor = .black.withAlphaComponent(0.8)
    }
    
    let firstContinueView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let secondContinueView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // PinLayout 적용
        setUI()
        
        let titleHeight: CGFloat = self.bounds.size.height * 4.1 / 5
         var diameter: CGFloat = min(self.bounds.size.height * 5.2 / 8, self.bounds.size.width)
         diameter = diameter > FSCalendarStandardCellDiameter ? (diameter - (diameter-FSCalendarStandardCellDiameter) * 0.5) : diameter
         shapeLayer.frame = CGRect(x: ((bounds.size.width - diameter) / 2) - 6,
                                   y: ((titleHeight - diameter) / 2) - 3,
                                   width: diameter + 12, height: diameter + 14)
         
         let path = UIBezierPath(roundedRect: shapeLayer.bounds, cornerRadius: shapeLayer.bounds.width * 0.5 * appearance.borderRadius).cgPath
         if shapeLayer.path != path {
             shapeLayer.path = path
         }
    }
    
    func configure() {
        [line, firsTagLine, firstTitle, secondTagLine, secondTitle, plusLabel, firstContinueView, secondContinueView].forEach {
            self.addSubview($0)
        }
    }
    
    func setUI() {
        titleLabel.pin
            .top(2)
            .hCenter()
            .sizeToFit()
        
        line.pin
            .top(-4)
            .height(1)
            .horizontally()
        
        firsTagLine.pin
            .left(9)
            .top(18)
            .width(3)
            .height(10)
        
        firstTitle.pin
            .after(of: firsTagLine)
            .marginLeft(3)
            .top(18)
            .right(5)
            .height(10)
        
        secondTagLine.pin
            .left(9)
            .below(of: firsTagLine)
            .marginTop(2)
            .width(3)
            .height(10)
        
        secondTitle.pin
            .after(of: secondTagLine)
            .marginLeft(3)
            .below(of: firsTagLine)
            .marginTop(2)
            .right(5)
            .height(10)
        
        plusLabel.pin
            .left(9)
            .below(of: secondTagLine)
            .marginTop(2)
            .right()
            .height(10)
        
        firstContinueView.pin
            .top(18)
            .left()
            .right()
            .height(10)
        
        secondContinueView.pin
            .below(of: firsTagLine)
            .marginTop(2)
            .left()
            .right()
            .height(10)
        
    }
    
    func bind(_ events: [CalendarEvent], beforeDate: [CalendarEvent], afterDate: [CalendarEvent] , isSelected: Bool) {
        
        firstContinueView.backgroundColor = .clear
        secondContinueView.backgroundColor = .clear
        
        // 선택 시 글자색 흰색으로 변경
        if isSelected {
            firstTitle.textColor = .white
            secondTitle.textColor = .white
            plusLabel.textColor = .white
        } else {
            firstTitle.textColor = .black.withAlphaComponent(0.8)
            secondTitle.textColor = .black.withAlphaComponent(0.8)
            plusLabel.textColor = .black.withAlphaComponent(0.8)
        }
        
        // 이벤트 수에따른 Cell UI 변경
        if events.count == 0 {
            firsTagLine.backgroundColor = .clear
            secondTagLine.backgroundColor = .clear
            
            firstTitle.text = ""
            secondTitle.text = ""
            plusLabel.text = ""
        } else if events.count >= 1 {
            firsTagLine.backgroundColor = events[0].tagColor.toUIColor()
            firstTitle.text = events[0].title
            
            secondTagLine.backgroundColor = .clear
            secondTitle.text = ""
            plusLabel.text = ""
            
            if events.count >= 2 {
                secondTagLine.backgroundColor = events[1].tagColor.toUIColor()
                secondTitle.text = events[1].title
                
                if events.count > 2 {
                    plusLabel.text = "+\(events.count - 2)"
                }
            }
        }
        
        
        // 앞 뒤 이벤트에 따라 continueView 그리기
        if events.count >= 1 && afterDate.count >= 1 {
            if events[0] == afterDate[0] {
                firstContinueView.backgroundColor = events[0].tagColor.toUIColor()?.withAlphaComponent(0.15)
               
            }
        }

        
        if events.count >= 1 && beforeDate.count >= 1 {
            if events[0] == beforeDate[0] {
                firstContinueView.backgroundColor = events[0].tagColor.toUIColor()?.withAlphaComponent(0.15)
                firstTitle.text = ""
                firsTagLine.backgroundColor = .clear
            }
        }

        if events.count >= 2 && afterDate.count >= 2 {
            if events[1] == afterDate[1] {
                secondContinueView.backgroundColor = events[1].tagColor.toUIColor()?.withAlphaComponent(0.15)
            }
        }
        
        if events.count >= 2 && beforeDate.count >= 2 {
            if events[1] == beforeDate[1] {
                secondContinueView.backgroundColor = events[1].tagColor.toUIColor()?.withAlphaComponent(0.15)
                secondTitle.text = ""
                secondTagLine.backgroundColor = .clear
            }
        }
        
    }
}
