
import Foundation
import UIKit

class CalendarDayCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CalendarDayCell"
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.blue
        label = UILabel()
        label.numberOfLines = 0
        contentView.addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    func configure(with displayedDate: CalendarDays.GetCalanderDays.ViewModel.DisplayedDate, isSelected: Bool) {
        label.text = "\(displayedDate.weekDay), day: \(displayedDate.calendarDay), month: \(displayedDate.month)"
        if isSelected {
            contentView.backgroundColor = UIColor.yellow
        } else {
            contentView.backgroundColor = UIColor.blue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
