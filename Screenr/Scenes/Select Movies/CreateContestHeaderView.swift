
import Foundation
import UIKit

final class CreateContestHeaderView: UIView {
    
    var totalStages: Int
    var containerView: UIView!
    var headerLabel: UILabel!
    var messageLabel: UILabel!
    var labelStackView: UIStackView!
    var backButton: UIButton!
    var progressView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(currentStage: Int, totalStages: Int) {
        self.totalStages = totalStages
        super.init(frame: .zero)
        self.backgroundColor = UIColor.clear
        setupContainerView()
        setupHeaderLabel()
        setupMessageLabel()
        setupLabelStackView()
        setupBackButton()
        setupProgressView(for: currentStage)
    }
    
    fileprivate func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = UIColor.gray
        
        self.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.constrainEdges(to: self)
    }
    
    fileprivate func setupHeaderLabel() {
        headerLabel = UILabel()
        headerLabel.font = FontBook.AvenirHeavy.of(size: 13)
        headerLabel.textColor = UIColor.yellow
    }
    
    fileprivate func setupMessageLabel() {
        messageLabel = UILabel()
        messageLabel.font = FontBook.AvenirHeavy.of(size: 13)
        messageLabel.textColor = UIColor.white
    }
    
    fileprivate func setupLabelStackView() {
        labelStackView = UIStackView(arrangedSubviews: [headerLabel, messageLabel])
        labelStackView.axis = .vertical
        labelStackView.spacing = 2.0
        labelStackView.alignment = .center
        
        containerView.addSubview(labelStackView)
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        labelStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 65).isActive = true
    }
    
    fileprivate func setupBackButton() {
        backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "IC_Back Arrow"), for: .normal)
        
        containerView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.064).isActive = true
        backButton.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.064).isActive = true
        backButton.trailingAnchor.constraint(equalTo: labelStackView.leadingAnchor, constant: -20).isActive = true
        backButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -10).isActive = true
    }
    
    fileprivate func setupProgressView(for currentStage: Int) {
        progressView = UIView()
        progressView.backgroundColor = UIColor.yellow
        
        containerView.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        progressView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        progressView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: CGFloat(currentStage/totalStages)).isActive = true
    }
    
}

