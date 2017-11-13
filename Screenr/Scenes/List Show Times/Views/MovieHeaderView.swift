
import Foundation
import UIKit

final class MovieHeaderView: UIView {
    
    private let height1X: CGFloat = 154.0
    var containerView: UIView!
    var backButton: UIButton!
    var titleLabel: UILabel!
    var height: CGFloat {
        return Screen.height * (height1X / Screen.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.clear
        setupContainerView()
        setupBackButton()
        setupTitleLabel()
    }
    
    fileprivate func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.constrainEdges(to: self)
    }
    
    fileprivate func setupBackButton() {
        backButton = UIButton()
        backButton.backgroundColor = UIColor.red
        
        containerView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.053).isActive = true
        backButton.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.043).isActive = true
        backButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 22).isActive = true
        backButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
    }
    
    fileprivate func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.font = FontBook.AvenirHeavy.of(size: 13)
        titleLabel.textColor = UIColor.white
        
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
    }
    
}
