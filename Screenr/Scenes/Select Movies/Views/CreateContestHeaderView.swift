
import Foundation
import UIKit
import SnapKit

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
        setupBackButton()
        setupLabelStackView()
        setupProgressView(for: currentStage)
    }
    
    fileprivate func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = Palette.darkGrey.color
        
        self.addSubview(containerView)
        containerView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
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
        labelStackView.snp.makeConstraints { (make) in
            make.centerY.equalTo(containerView)
            make.leading.equalTo(containerView).offset(65)
            make.trailing.equalTo(containerView).offset(-35)
        }
    }
    
    fileprivate func setupBackButton() {
        backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "IC_SmallBackButton"), for: .normal)
        
        containerView.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.height.equalTo(Device.height * 0.0239)
            make.width.equalTo(Device.width * 0.0533)
            make.leading.equalTo(containerView).offset(20)
            make.top.equalTo(containerView).offset(44)
        }
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

