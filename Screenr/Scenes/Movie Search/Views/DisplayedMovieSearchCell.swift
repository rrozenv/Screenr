
import Foundation
import UIKit
import Kingfisher

final class DisplayedMovieSearchCell: UITableViewCell {
    
    // MARK: - Type Properties
    
    static let reuseIdentifier = "DisplayedMovieSearchCell"
    
    // MARK: - Properties
    
    fileprivate var containerView: UIView!
    fileprivate var posterImageView: UIImageView!
    fileprivate var nameLabel: UILabel!
    fileprivate var yearLabel: UILabel!
    
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
        self.contentView.backgroundColor = UIColor.white
        setupContainerView()
        setupImageView()
        setupNameLabel()
    }
    
    func configure(with displayedMovie: DisplayedMovieInSearch) {
        self.selectionStyle = .none
        nameLabel.text = displayedMovie.title
        yearLabel.text = displayedMovie.year
        if let posterURL = URL(string: displayedMovie.posterURL) {
            posterImageView.kf.setImage(with: posterURL)
        }
    }
    
    override func prepareForReuse() {
        containerView.backgroundColor = UIColor.white
    }
    
    fileprivate func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = UIColor.white
        contentView.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func setupImageView() {
        posterImageView = UIImageView()
        posterImageView.contentMode = .scaleAspectFill
        
        containerView.addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        posterImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        posterImageView.widthAnchor.constraint(equalToConstant: 46).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: 54).isActive = true
    }
    
    func setupNameLabel() {
        nameLabel = UILabel()
        nameLabel.font = UIFont(name: "Avenir-Medium", size: 12)
        nameLabel.textColor = UIColor.black
        
        yearLabel = UILabel()
        yearLabel.font = UIFont(name: "Avenir-Medium", size: 12)
        yearLabel.textColor = UIColor.gray
        yearLabel.numberOfLines = 1
        yearLabel.lineBreakMode = .byTruncatingTail
        
        let labels: [UILabel] = [nameLabel, yearLabel]
        let labelsStack = UIStackView(arrangedSubviews: labels)
        labelsStack.spacing = 4.0
        labelsStack.axis = .vertical
        
        containerView.addSubview(labelsStack)
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20).isActive = true
        labelsStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    }
    
}
