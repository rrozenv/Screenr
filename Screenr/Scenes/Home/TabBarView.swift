
import Foundation
import UIKit

final class TabBarView: UIView {
    
    //MARK: View Properties
    var containerView: UIView!
    var leftButton: UIButton!
    var rightButton: UIButton!
    
    //MARK: Initalizer Setup
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(leftTitle: String, rightTitle: String) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.clear
        setupBackgroundView()
        setupLeftButton(with: leftTitle)
        setupRightButton(with: rightTitle)
    }
    
    func didSelect(tabButtonType: HomeViewController.TabButtonType) {
        switch tabButtonType {
        case .mainMovieList:
            leftButton.backgroundColor = UIColor.black
            rightButton.backgroundColor = UIColor.gray
        case .contests:
            leftButton.backgroundColor = UIColor.gray
            rightButton.backgroundColor = UIColor.black
        }
    }

}

extension TabBarView {
    
    fileprivate func setupBackgroundView() {
        containerView = UIView()
        containerView.backgroundColor = UIColor.white
        
        self.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.constrainEdges(to: self)
    }
    
    fileprivate func setupLeftButton(with title: String) {
        leftButton = UIButton()
        leftButton.setTitle(title, for: .normal)
        leftButton.backgroundColor = UIColor.black
       
        containerView.addSubview(leftButton)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
        leftButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        leftButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        leftButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    fileprivate func setupRightButton(with title: String) {
        rightButton = UIButton()
        rightButton.setTitle(title, for: .normal)
        rightButton.backgroundColor = UIColor.black
        
        containerView.addSubview(rightButton)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
        rightButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        rightButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        rightButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
}

final class CustomNavigationBar: UIView {
    
    //MARK: View Properties
    var containerView: UIView!
    var leftButton: UIButton!
    var centerButton: UIButton!
    var rightButton: UIButton!
    var locationLabel: UILabel!
    
    //MARK: Initalizer Setup
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(leftImage: UIImage, centerImage: UIImage, rightImage: UIImage) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.clear
        setupBackgroundView()
        setupLeftButton(with: leftImage)
        setupCenterButton(with: centerImage)
        setupRightButton(with: rightImage)
        setupLocationLabel()
    }
    
}

extension CustomNavigationBar {
    
    fileprivate func setupBackgroundView() {
        containerView = UIView()
        containerView.backgroundColor = UIColor.white
        
        self.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.constrainEdges(to: self)
    }
    
    fileprivate func setupLeftButton(with image: UIImage) {
        leftButton = UIButton()
        leftButton.backgroundColor = UIColor.clear
        leftButton.setImage(image, for: .normal)
        
        containerView.addSubview(leftButton)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.064).isActive = true
        leftButton.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.064).isActive = true
        leftButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        leftButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    }
    
    fileprivate func setupCenterButton(with image: UIImage) {
        centerButton = UIButton()
        centerButton.backgroundColor = UIColor.clear
        centerButton.setImage(image, for: .normal)
        
        containerView.addSubview(centerButton)
        centerButton.translatesAutoresizingMaskIntoConstraints = false
        centerButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.2267).isActive = true
        centerButton.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.1786).isActive = true
        centerButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        centerButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    fileprivate func setupRightButton(with image: UIImage) {
        rightButton = UIButton()
        rightButton.backgroundColor = UIColor.clear
        rightButton.setImage(image, for: .normal)
        
        containerView.addSubview(rightButton)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.060).isActive = true
        rightButton.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.068).isActive = true
        rightButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        rightButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    }
    
    fileprivate func setupLocationLabel() {
        locationLabel = UILabel()
        locationLabel.textColor = UIColor.yellow
        locationLabel.font = FontBook.AvenirHeavy.of(size: 12)
        
        containerView.insertSubview(locationLabel, aboveSubview: centerButton)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.centerXAnchor.constraint(equalTo: centerButton.centerXAnchor, constant: 6).isActive = true
        locationLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -6).isActive = true
    }
    
}
