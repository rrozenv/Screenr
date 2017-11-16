
import Foundation
import UIKit

final class CustomAlertViewController: UIViewController {
    
    var customAlertView: CustomAlertView!
    var buttonCount: ButtonCount = .one
    var alertInfo = AlertInfo(header: "Header",
                              message: "Message",
                              okButtonTitle: nil,
                              cancelButtonTitle: nil)
    var okAction: (() -> ())?
    var cancelAction: (() -> ())?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(alertInfo: AlertInfo, okAction: (() -> Void)?) {
        self.init(nibName: nil, bundle: nil)
        self.buttonCount = .one
        self.alertInfo = alertInfo
        self.okAction = okAction
    }
    
    convenience init(alertInfo: AlertInfo, okAction: (() -> Void)?, cancelAction: (() -> Void)?) {
        self.init(nibName: nil, bundle: nil)
        self.buttonCount = .two
        self.alertInfo = alertInfo
        self.okAction = okAction
        self.cancelAction = cancelAction
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        setupCustomAlertView()
        configureAlertView(with: alertInfo)
    }
    
    deinit {
        print("deinit of custom contorl")
    }
    
}

extension CustomAlertViewController {
    
    fileprivate func configureAlertView(with alertInfo: AlertInfo) {
        customAlertView.headerLabel.text = alertInfo.header
        customAlertView.messageLabel.text = alertInfo.message
        switch buttonCount {
        case .one:
            customAlertView.singleButton.setTitle(alertInfo.okButtonTitle, for: .normal)
        case .two:
            customAlertView.cancelButton.setTitle(alertInfo.cancelButtonTitle, for: .normal)
            customAlertView.okButton.setTitle(alertInfo.okButtonTitle, for: .normal)
        }
    }
    
    @objc fileprivate func didSelectOkButton(_ sender: UIButton) {
        self.okAction?()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func didSelectCancelButton(_ sender: UIButton) {
        self.cancelAction?()
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CustomAlertViewController {
    
    fileprivate func setupCustomAlertView() {
        customAlertView = CustomAlertView(buttonCount: buttonCount)
        switch buttonCount {
        case .one:
            customAlertView.singleButton.addTarget(self, action: #selector(didSelectOkButton(_:)), for: .touchUpInside)
        case .two:
            customAlertView.okButton.addTarget(self, action: #selector(didSelectOkButton(_:)), for: .touchUpInside)
            customAlertView.cancelButton.addTarget(self, action: #selector(didSelectCancelButton(_:)), for: .touchUpInside)
        }
        
        self.view.addSubview(customAlertView)
        customAlertView.translatesAutoresizingMaskIntoConstraints = false
        customAlertView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customAlertView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        customAlertView.widthAnchor.constraint(equalToConstant: Screen.width * 0.6).isActive = true
    }
    
}

extension CustomAlertViewController {
    
    enum ButtonCount {
        case one, two
    }
    
    struct AlertInfo {
        let header: String
        let message: String
        let okButtonTitle: String
        let cancelButtonTitle: String
        
        init(header: String, message: String, okButtonTitle: String?, cancelButtonTitle: String?) {
            self.header = header
            self.message = message
            self.okButtonTitle = okButtonTitle ?? "OK"
            self.cancelButtonTitle = cancelButtonTitle ?? "CANCEL"
        }
    }
    
}

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

