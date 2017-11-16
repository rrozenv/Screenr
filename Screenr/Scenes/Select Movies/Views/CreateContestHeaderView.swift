
import Foundation
import UIKit

final class CreateContestHeaderView: UIView {
    
    var totalStages: CGFloat
    var containerView: UIView!
    var headerLabel: UILabel!
    var messageLabel: UILabel!
    var labelStackView: UIStackView!
    var backButton: UIButton!
    var progressView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(currentStage: CGFloat, totalStages: CGFloat) {
        self.totalStages = totalStages
        super.init(frame: .zero)
        self.backgroundColor = UIColor.clear
        self.dropShadow()
        setupContainerView()
        setupHeaderLabel()
        setupMessageLabel()
        setupLabelStackView()
        setupBackButton()
        setupProgressView(for: currentStage)
    }
    
    fileprivate func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = Palette.darkGrey.color
        
        self.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.constrainEdges(to: self)
    }
    
    fileprivate func setupHeaderLabel() {
        headerLabel = UILabel()
        headerLabel.font = FontBook.AvenirHeavy.of(size: 17)
        headerLabel.textColor = UIColor.yellow
    }
    
    fileprivate func setupMessageLabel() {
        messageLabel = UILabel()
        messageLabel.font = FontBook.AvenirMedium.of(size: 14)
        messageLabel.textColor = UIColor.white
        messageLabel.numberOfLines = 0
    }
    
    fileprivate func setupLabelStackView() {
        labelStackView = UIStackView(arrangedSubviews: [headerLabel, messageLabel])
        labelStackView.axis = .vertical
        labelStackView.spacing = 2.0
        labelStackView.alignment = .leading
        
        containerView.addSubview(labelStackView)
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 4).isActive = true
        labelStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 65).isActive = true
        labelStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -35).isActive = true
    }
    
    fileprivate func setupBackButton() {
        backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "IC_SmallBackButton"), for: .normal)
        
        containerView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.0267).isActive = true
        backButton.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.0453).isActive = true
        backButton.trailingAnchor.constraint(equalTo: labelStackView.leadingAnchor, constant: -24).isActive = true
        backButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -15).isActive = true
    }
    
    fileprivate func setupProgressView(for currentStage: CGFloat) {
        progressView = UIView()
        progressView.backgroundColor = UIColor.yellow
        
        containerView.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        progressView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        progressView.widthAnchor.constraint(equalToConstant: Screen.width * currentStage/totalStages).isActive = true
    }
    
}

