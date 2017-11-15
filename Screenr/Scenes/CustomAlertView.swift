
import Foundation
import UIKit

final class CustomAlertView: UIView {
    
    var containerView: UIView!
    var headerLabel: UILabel!
    var messageLabel: UILabel!
    var okButton: UIButton!
    var cancelButton: UIButton!
    var stackView: UIStackView!
    var singleButton: UIButton!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.yellow
        setupContainerView()
        //setupSingleButton()
        setupOkButton()
        setupCancelButton()
        setupButtonStackView()
        setupTitleLabel()
    }
    
    fileprivate func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = UIColor.white
        
        self.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.constrainEdges(to: self)
    }
    
    fileprivate func setupOkButton() {
        okButton = UIButton()
        okButton.setTitle("OK", for: .normal)
        okButton.backgroundColor = UIColor.red
    }
    
    fileprivate func setupCancelButton() {
        cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = UIColor.orange
    }
    
    fileprivate func setupButtonStackView() {
        stackView = UIStackView(arrangedSubviews: [cancelButton, okButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: Screen.height * 0.09).isActive = true
    }
    
    fileprivate func setupTitleLabel() {
        headerLabel = UILabel()
        headerLabel.font = FontBook.AvenirHeavy.of(size: 13)
        headerLabel.textColor = UIColor.black
        
        containerView.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -10).isActive = true
    }
    
    fileprivate func setupSingleButton() {
        singleButton = UIButton()
        singleButton.setTitle("Single Button", for: .normal)
        
        containerView.addSubview(singleButton)
        singleButton.translatesAutoresizingMaskIntoConstraints = false
        singleButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        singleButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        singleButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        singleButton.heightAnchor.constraint(equalToConstant: Screen.height * 0.09).isActive = true
    }
    
}
