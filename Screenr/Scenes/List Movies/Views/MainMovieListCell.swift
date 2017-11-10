
import Foundation
import UIKit

class MainMovieListCell: UICollectionViewCell {
    
    static let reuseIdentifier = "MainMovieListCell"
    var containerView: UIView!
    var titleBackgroundView: UIView!
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.dropShadow(scale: true)
        contentView.backgroundColor = UIColor.blue
        contentView.layer.cornerRadius = 2.0
        contentView.layer.masksToBounds = true
        setupContainerView()
        setupTitleBackground()
        setupTitleLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        containerView.layer.cornerRadius = 2.0
        containerView.layer.masksToBounds = true
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.constrainEdges(to: contentView)
    }
    
    fileprivate func setupTitleBackground() {
        titleBackgroundView = UIView()
        titleBackgroundView.backgroundColor = UIColor.red
        
        containerView.addSubview(titleBackgroundView)
        titleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        titleBackgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        titleBackgroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        titleBackgroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    fileprivate func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.numberOfLines = 3
        titleLabel.textColor = UIColor.white
        titleLabel.font = FontBook.AvenirHeavy.of(size: 13)
        titleLabel.textAlignment = .left
        
        titleBackgroundView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: titleBackgroundView.leadingAnchor, constant: 15).isActive = true
        titleLabel.topAnchor.constraint(equalTo: titleBackgroundView.topAnchor, constant: 12).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: titleBackgroundView.bottomAnchor, constant: -12).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: titleBackgroundView.trailingAnchor, constant: -15).isActive = true
    }
    
}


