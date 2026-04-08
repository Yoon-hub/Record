//
//  EventSearchEventCell.swift
//  App
//

import UIKit

import Core
import Design
import Domain

/// 검색 결과: 날짜는 섹션 헤더에만 두고, 셀에는 제목·시간·메모만.
/// 행 높이는 `UITableView.automaticDimension`을 위해 Auto Layout으로만 잡음 (PinLayout 사용 시 제목이 잘리는 문제 방지).
final class EventSearchEventCell: UITableViewCell {
    
    private let accentBar = UIView().then {
        $0.layer.cornerRadius = 2
    }
    
    private let titleLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 16)
        $0.numberOfLines = 0
        $0.textColor = .label
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    private let timeLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.medium.font(size: 14)
        $0.textColor = .secondaryLabel
        $0.numberOfLines = 0
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    private let memoLabel = UILabel().then {
        $0.font = DesignFontFamily.Pretendard.regular.font(size: 13)
        $0.textColor = .tertiaryLabel
        $0.numberOfLines = 2
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    private let mainStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        textLabel?.isHidden = true
        detailTextLabel?.isHidden = true
        
        accentBar.translatesAutoresizingMaskIntoConstraints = false
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(accentBar)
        contentView.addSubview(mainStack)
        [titleLabel, timeLabel, memoLabel].forEach { mainStack.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            accentBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            accentBar.widthAnchor.constraint(equalToConstant: 4),
            accentBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            accentBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            mainStack.leadingAnchor.constraint(equalTo: accentBar.trailingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        timeLabel.text = nil
        memoLabel.text = nil
        memoLabel.isHidden = true
    }
    
    func configure(with event: CalendarEvent, occurrenceDay: Date) {
        titleLabel.text = event.title
        timeLabel.text = Self.timeLine(for: event, occurrenceDay: occurrenceDay)
        if let memo = event.content?.trimmingCharacters(in: .whitespacesAndNewlines), !memo.isEmpty {
            memoLabel.text = memo
            memoLabel.isHidden = false
        } else {
            memoLabel.text = nil
            memoLabel.isHidden = true
        }
        accentBar.backgroundColor = event.tagColor.toUIColor() ?? Theme.theme
    }
    
    private static func timeLine(for event: CalendarEvent, occurrenceDay: Date) -> String {
        let cal = Calendar.current
        let start = event.displayStartDate(forCalendarDay: occurrenceDay)
        let end = event.displayEndDate(forCalendarDay: occurrenceDay)
        
        if !cal.isDate(start, inSameDayAs: end) {
            let sd = start.formattedDateString(type: .simpleMonthDay)
            let st = start.formatToTime24Hour()
            let ed = end.formattedDateString(type: .simpleMonthDay)
            let et = end.formatToTime24Hour()
            return "\(sd) \(st) → \(ed) \(et)"
        }
        
        if start == end {
            return start.formatToTime24Hour()
        }
        
        let sc = cal.dateComponents([.hour, .minute], from: start)
        let ec = cal.dateComponents([.hour, .minute], from: end)
        if sc.hour == 0 && sc.minute == 0 && ec.hour == 23 && ec.minute == 59 {
            return "하루 종일"
        }
        
        return "\(start.formatToTime24Hour()) ~ \(end.formatToTime24Hour())"
    }
}
