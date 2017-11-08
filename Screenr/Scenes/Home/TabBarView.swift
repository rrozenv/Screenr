
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
