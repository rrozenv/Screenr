
import Foundation
import UIKit

final class TheatreTableViewCell: UITableViewCell {
    
    // MARK: - Type Properties
    
    static let reuseIdentifier = "TheatreCell"
    
    // MARK: - Properties
    
    fileprivate var theatreNameLabel: UILabel!
    fileprivate var showtimesLabel: UILabel!
    fileprivate var containerView: UIView!
    
    // MARK: - Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        setupContainerView()
        setupLabels()
    }
    
    func configure(with displayedTheatre: ListShowtimes.GetShowtimes.ViewModel.DisplayedTheatre) {
        var showtimeString = ""
        displayedTheatre.showtimes?.forEach({
            showtimeString += ", \($0.time)"
        })
        theatreNameLabel.text = displayedTheatre.name
        showtimesLabel.text = showtimeString
    }
    
    fileprivate func setupContainerView() {
        containerView = UIView()
        contentView.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    fileprivate func setupLabels() {
        theatreNameLabel = UILabel()
        theatreNameLabel.numberOfLines = 1
        containerView.addSubview(theatreNameLabel)
        
        theatreNameLabel.translatesAutoresizingMaskIntoConstraints = false
        theatreNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        theatreNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30).isActive = true
        theatreNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        
        showtimesLabel = UILabel()
        showtimesLabel.numberOfLines = 1
        containerView.addSubview(showtimesLabel)
        
        showtimesLabel.translatesAutoresizingMaskIntoConstraints = false
        showtimesLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        showtimesLabel.topAnchor.constraint(equalTo: theatreNameLabel.bottomAnchor, constant: 30).isActive = true
        showtimesLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
    }
    
}
