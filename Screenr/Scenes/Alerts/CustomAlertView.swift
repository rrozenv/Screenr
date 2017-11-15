
import Foundation
import UIKit

final class CustomAlertView: UIView {
    
    var containerView: UIView!
    
    var headerLabel: UILabel!
    var messageLabel: UILabel!
    var labelStackView: UIStackView!
    
    var okButton: UIButton!
    var cancelButton: UIButton!
    var stackView: UIStackView!
    
    var singleButton: UIButton!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(buttonCount: CustomAlertViewController.ButtonCount) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.yellow
        setupContainerView()
       
        switch buttonCount {
        case .one:
            setupSingleButton()
        case .two:
            setupOkButton()
            setupCancelButton()
            setupButtonStackView()
        }
        
        setupHeaderLabel()
        setupMessageLabel()
        setupLabelStackView(given: buttonCount)
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
        okButton.backgroundColor = UIColor.red
    }
    
    fileprivate func setupCancelButton() {
        cancelButton = UIButton()
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
    
    fileprivate func setupHeaderLabel() {
        headerLabel = UILabel()
        headerLabel.font = FontBook.AvenirHeavy.of(size: 13)
        headerLabel.textColor = UIColor.black
    }
    
    fileprivate func setupMessageLabel() {
        messageLabel = UILabel()
        messageLabel.font = FontBook.AvenirHeavy.of(size: 13)
        messageLabel.textColor = UIColor.black
    }
    
    fileprivate func setupLabelStackView(given buttonCount: CustomAlertViewController.ButtonCount) {
        labelStackView = UIStackView(arrangedSubviews: [headerLabel, messageLabel])
        labelStackView.axis = .vertical
        labelStackView.spacing = 2.0
        labelStackView.alignment = .center
        
        containerView.addSubview(labelStackView)
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        labelStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        switch buttonCount {
        case .one:
            labelStackView.bottomAnchor.constraint(equalTo: singleButton.topAnchor, constant: -10).isActive = true
        case .two:
            labelStackView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -10).isActive = true
        }
    }
    
    fileprivate func setupSingleButton() {
        singleButton = UIButton()
        singleButton.backgroundColor = UIColor.gray
        
        containerView.addSubview(singleButton)
        singleButton.translatesAutoresizingMaskIntoConstraints = false
        singleButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        singleButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        singleButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        singleButton.heightAnchor.constraint(equalToConstant: Screen.height * 0.09).isActive = true
    }
    
}
