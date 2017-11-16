
import Foundation
import UIKit

final class SelectTheatreViewController: UIViewController, ChildViewControllerManager {
    
    let stage = CreateContestStage.selectTheatre
    var headerView: CreateContestHeaderView!
    var theatreSearchViewController: MovieSearchViewController!
    var nextButton: UIButton!
    
    var engine: SelectTheatreLogic?
    var router:
    (SelectTheatreRoutingLogic &
    NSObjectProtocol)?
    
    var postalCodeButton: UIBarButtonItem!
    var locationDidChange = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let viewController = self
        let engine = SelectTheatreEngine()
        let router = SelectTheatreRouter()
        viewController.engine = engine
        viewController.router = router
        router.viewController = viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        setupHeaderView()
        setupChildTheatreSearchViewController()
        setupTheatreSearchTableViewConstraints()
        setupNextButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return nextButton
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func didSelectNextButton(_ sender: UIButton) {
        engine?.saveSelectedTheatreToDatabase()
        router?.routeToCreateContestSummary()
    }
    
    func didTapBackButton(_ sender: UIButton) {
        router?.routeToSelectMovies()
    }
    
}

extension SelectTheatreViewController: MovieSearchControllerDelegate {
  
    func didSelectTheatre(_ theatre: Theatre_R) {
        engine?.saveSelectedTheatreToDataStore(theatre)
    }
    
}

extension SelectTheatreViewController {
    
    fileprivate func setupHeaderView() {
        headerView = CreateContestHeaderView(currentStage: stage.rawValue, totalStages: CreateContestStage.totalStages)
        headerView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        headerView.headerLabel.text = stage.headerLabel
        headerView.messageLabel.text = stage.messageLabel
        
        self.view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.195).isActive = true
    }
    
    fileprivate func setupChildTheatreSearchViewController() {
        theatreSearchViewController = MovieSearchViewController(searchType: .theatres)
        theatreSearchViewController.delegate = self
        self.addTheatreSearch(asChildViewController: theatreSearchViewController)
    }
    
    fileprivate func setupTheatreSearchTableViewConstraints() {
        theatreSearchViewController.view.translatesAutoresizingMaskIntoConstraints = false
        theatreSearchViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        theatreSearchViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        theatreSearchViewController.view.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        theatreSearchViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    fileprivate func setupNextButton() {
        nextButton = UIButton()
        nextButton.backgroundColor = UIColor.yellow
        nextButton.addTarget(self, action: #selector(didSelectNextButton), for: .touchUpInside)
        nextButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
    }
    
    fileprivate func addTheatreSearch(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        view.insertSubview(viewController.view, belowSubview: headerView)
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }
    
}
