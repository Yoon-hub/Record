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
    
    /// Tag Spot
    let thirdTagSpot = UIView().then {
        $0.layer.cornerRadius = 2
        $0.backgroundColor = .clear
    }
    
    let fourthTagSpot = UIView().then {
        $0.layer.cornerRadius = 2
        $0.backgroundColor = .clear
    }
    
    let fifthTagSpot = UIView().then {
        $0.layer.cornerRadius = 2
        $0.backgroundColor = .clear
    }
    
    let sixthTagSpot = UIView().then {
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
    
    // 일기 작성 표시용 작은 도트
    let diaryDot = UIView().then {
        $0.backgroundColor = Theme.theme
        $0.layer.cornerRadius = 1.5
        $0.isHidden = true
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
         shapeLayer.frame = CGRect(x: ((bounds.size.width - diameter) / 2) - 8,
                                   y: ((titleHeight - diameter) / 2) - 5,
                                   width: diameter + 16, height: diameter + 18)
         
         let path = UIBezierPath(roundedRect: shapeLayer.bounds, cornerRadius: shapeLayer.bounds.width * 0.5 * appearance.borderRadius).cgPath
         if shapeLayer.path != path {
             shapeLayer.path = path
         }
    }
    
    func configure() {
        [line,
         firsTagLine,
         firstTitle,
         secondTagLine,
         secondTitle,
         plusLabel,
         firstContinueView,
         secondContinueView,
         thirdTagSpot,
         fourthTagSpot,
         fifthTagSpot,
         sixthTagSpot,
         diaryDot].forEach {
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
            .sizeToFit()
        
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
        
        thirdTagSpot.pin
            .after(of: plusLabel)
            .marginLeft(4)
            .vCenter(to: plusLabel.edge.vCenter)
            .height(7)
            .width(2)
        
        fourthTagSpot.pin
            .after(of: thirdTagSpot)
            .marginLeft(2)
            .vCenter(to: plusLabel.edge.vCenter)
            .height(7)
            .width(2)
        
        fifthTagSpot.pin
            .after(of: fourthTagSpot)
            .marginLeft(2)
            .vCenter(to: plusLabel.edge.vCenter)
            .height(7)
            .width(2)
        
        sixthTagSpot.pin
            .after(of: fifthTagSpot)
            .marginLeft(2)
            .vCenter(to: plusLabel.edge.vCenter)
            .height(7)
            .width(2)
        
        // 일기 도트는 날짜 옆에 작게 표시
        diaryDot.pin
            .after(of: titleLabel)
            .marginLeft(3)
            .vCenter(to: titleLabel.edge.vCenter)
            .size(3)
        
    }
    
    func bind(_ events: [CalendarEvent], beforeDate: [CalendarEvent], afterDate: [CalendarEvent] , isSelected: Bool, hasDiary: Bool = false) {
        
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
            [firsTagLine,
             secondTagLine,
             thirdTagSpot,
             fourthTagSpot,
             fifthTagSpot,
             sixthTagSpot
            ].forEach { $0.backgroundColor = .clear }
            
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
                    
                    for i in 0...events.count - 1 {
                        if i == 2 {
                            thirdTagSpot.backgroundColor = events[i].tagColor.toUIColor()
                        }
                        
                        if i == 3 {
                            fourthTagSpot.backgroundColor = events[i].tagColor.toUIColor()
                        }
                        
                        if i == 4 {
                            fifthTagSpot.backgroundColor = events[i].tagColor.toUIColor()
                        }
                         
                        if i == 5 {
                            sixthTagSpot.backgroundColor = events[i].tagColor.toUIColor()
                        }

                    }
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
        
        // 일기 작성 여부에 따라 도트 표시
        diaryDot.isHidden = !hasDiary
        if isSelected {
            diaryDot.backgroundColor = .white
        } else {
            diaryDot.backgroundColor = Theme.theme
        }
    }
}
