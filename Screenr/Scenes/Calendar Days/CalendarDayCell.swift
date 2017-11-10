
import Foundation
import UIKit

class CalendarDayCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CalendarDayCell"
    var weekDaylabel: UILabel!
    var calendarDayLabel: UILabel!
    var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.clear
        setupWeekDayLabelProperties()
        setupCalendarDayLabelProperties()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupStackViewConstraints()
    }
    
    func configure(with displayedDate: CalendarDays.GetCalanderDays.ViewModel.DisplayedDate, isSelected: Bool) {
        weekDaylabel.text = displayedDate.weekDay
        calendarDayLabel.text = displayedDate.calendarDay
        contentView.backgroundColor = isSelected ? UIColor.yellow : UIColor.gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWeekDayLabelProperties() {
        weekDaylabel = UILabel()
        weekDaylabel.numberOfLines = 0
        weekDaylabel.font = FontBook.AvenirMedium.of(size: 14)
        weekDaylabel.textColor = UIColor.white
    }
    
    private func setupCalendarDayLabelProperties() {
        calendarDayLabel = UILabel()
        calendarDayLabel.numberOfLines = 0
        calendarDayLabel.font = FontBook.AvenirBlack.of(size: 26)
        calendarDayLabel.textColor = UIColor.white
    }
    
    private func setupStackViewConstraints() {
        let labels: [UILabel] = [weekDaylabel, calendarDayLabel]
        stackView = UIStackView(arrangedSubviews: labels)
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.axis = .vertical
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
}
