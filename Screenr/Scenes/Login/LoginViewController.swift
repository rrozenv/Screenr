
import UIKit

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
}

class LoginViewController: UIViewController {
    
    var signUpButtonBottomConstraint: NSLayoutConstraint!
    var textFieldPressedCounter = 1
    
    var router: (NSObjectProtocol & LoginDataPassing)?
    var engine: LoginBusinessLogic?
    
    var didSelectDate: ((String) -> ())?
    
    let nameTextField: TextField = {
        let tf = TextField()
        tf.placeholder = "Name"
        tf.backgroundColor = UIColor.gray
        tf.layer.cornerRadius = 4.0
        tf.layer.masksToBounds = true
        tf.font = UIFont(name: "Avenir-Medium", size: 14.0)
        tf.textColor = UIColor.black
        return tf
    }()
    
    let emailTextField: TextField = {
        let tf = TextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor.gray
        tf.layer.cornerRadius = 4.0
        tf.layer.masksToBounds = true
        tf.font = UIFont(name: "Avenir-Medium", size: 14.0)
        tf.textColor = UIColor.black
        return tf
    }()
    
    let passwordTextField: TextField = {
        let tf = TextField()
        tf.placeholder = "Password"
        tf.backgroundColor = UIColor.gray
        tf.layer.cornerRadius = 4.0
        tf.layer.masksToBounds = true
        tf.font = UIFont(name: "Avenir-Medium", size: 14.0)
        tf.textColor = UIColor.black
        return tf
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.blue
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        button.layer.cornerRadius = 4.0
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.orange
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        button.layer.cornerRadius = 4.0
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleNewUserRegistration), for: .touchUpInside)
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let engine = LoginEngine()
        let presenter = LoginPresenter()
        let router = LoginRouter()
        viewController.engine = engine
        viewController.router = router
        engine.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = engine
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFieldsAndSignUpButton()
        view.backgroundColor = UIColor.white
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Login diassapered")
//        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func handleNewUserRegistration() {
        guard let name = nameTextField.text,
            let email = emailTextField.text?.lowercased(),
            let password = passwordTextField.text else { print("Form is not valid"); return }
        
        let request = Login.Request(name: name, email: email, password: password)
        engine?.createUser(request: request)
    }

    func handleLogin() {
        guard let email = emailTextField.text?.lowercased(),
              let password = passwordTextField.text else { print("Form is not valid"); return }
        
        let request = Login.Request(name: nil, email: email, password: password)
        engine?.loginUser(request: request)
    }
    
    func displayMessage(viewModel: Login.ViewModel) {
        let title = viewModel.displayedMessage.header
        let body = viewModel.displayedMessage.body
        let isSuccess = viewModel.displayedMessage.isSuccess
        let alertController = UIAlertController(title: title, message: body, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if isSuccess {
                NotificationCenter.default.post(name: .closeLoginVC, object: nil)
            }
        }
        alertController.addAction(alertAction)
        self.showDetailViewController(alertController, sender: nil)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func setupTextFieldsAndSignUpButton() {
        let textFields = [nameTextField, emailTextField, passwordTextField]
        
        for textField in textFields {
            textField.delegate = self
        }
        
        let stackView = UIStackView(arrangedSubviews: textFields)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.0).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.0).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -98.0).isActive = true 
        
        view.addSubview(registerButton)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.0).isActive = true
        registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.0).isActive = true
        registerButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -15).isActive = true
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: registerButton.topAnchor, constant: -10.0).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 155).isActive = true
    }

    func keyboardWillShow(_ notification:Notification) {
        if textFieldPressedCounter <= 1 {
            adjustingHeight(true, notification: notification)
            textFieldPressedCounter += 1
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if textFieldPressedCounter != 1 {
            adjustingHeight(false, notification: notification)
            textFieldPressedCounter = 1
        }
    }
    
    func adjustingHeight(_ show:Bool, notification:Notification) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let changeInHeight = (keyboardFrame.height - 40) * (show ? -1 : 1)
        self.signUpButtonBottomConstraint.constant += changeInHeight
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
