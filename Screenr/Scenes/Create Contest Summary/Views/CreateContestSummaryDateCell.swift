
import Foundation
import UIKit

final class CreateContestSummaryDateCell: UITableViewCell {
    
    // MARK: - Type Properties
    static let reuseIdentifier = "DateCell"
    
    // MARK: - Properties
    fileprivate var containerView: UIView!
    fileprivate var titleLabel: UILabel!
    fileprivate var dateLabel: UILabel!
    fileprivate var labelsStackView: UIStackView!
    var dateButton: UIButton!
    var timeButton: UIButton!
    
    // MARK: - Initialization
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupContainerViewConstraints()
        setupStackViewConstraints()
        setupDateButtonConstraints()
        setupTimeButtonConstraints()
    }
    
    func commonInit() {
        self.contentView.backgroundColor = UIColor.white
        setupContainerViewProperties()
        setupTitleLabelProperties()
        setupDateLabelProperties()
        setupLabelsStackViewProperties()
        setupDateButtonProperties()
        setupTimeButtonProperties()
    }
    
    func configure(with dateString: String?) {
        self.selectionStyle = .none
        titleLabel.text = "DATE & TIME"
        dateLabel.text = dateString ?? Date().yearMonthDayString
    }
    
    override func prepareForReuse() { }
    
}

//MARK: View Property Setup

extension CreateContestSummaryDateCell {
    
    fileprivate func setupContainerViewProperties() {
        containerView = UIView()
        containerView.backgroundColor = UIColor.white
    }
    
    func setupTitleLabelProperties() {
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.gray
        titleLabel.font = FontBook.AvenirMedium.of(size: 12)
    }
    
    func setupDateLabelProperties() {
        dateLabel = UILabel()
        dateLabel.textColor = UIColor.black
        dateLabel.font = FontBook.AvenirMedium.of(size: 12)
    }
    
    func setupLabelsStackViewProperties() {
        let views: [UILabel] = [titleLabel, dateLabel]
        labelsStackView = UIStackView(arrangedSubviews: views)
        labelsStackView.spacing = 4.0
        labelsStackView.axis = .vertical
    }
    
    func setupDateButtonProperties() {
        dateButton = UIButton()
        dateButton.backgroundColor = UIColor.clear
    }
    
    func setupTimeButtonProperties() {
        timeButton = UIButton()
        timeButton.backgroundColor = UIColor.clear
    }
    
}

//MARK: Constraints Setup

extension CreateContestSummaryDateCell {
    
    func setupContainerViewConstraints() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func setupStackViewConstraints() {
        containerView.addSubview(labelsStackView)
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        labelsStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    }
    
    func setupDateButtonConstraints() {
        containerView.addSubview(dateButton)
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        dateButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7).isActive = true
        dateButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        dateButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        dateButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
    }
    
    func setupTimeButtonConstraints() {
        containerView.addSubview(timeButton)
        timeButton.translatesAutoresizingMaskIntoConstraints = false
        timeButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.3).isActive = true
        timeButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        timeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        timeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
    
}
