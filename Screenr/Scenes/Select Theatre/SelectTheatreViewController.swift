
import Foundation
import UIKit

final class SelectTheatreViewController: UIViewController, ChildViewControllerManager {
    
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
        setupChildMovieSearchViewController()
        setupNextButton()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        theatreSearchViewController.view.frame = CGRect(x: 0, y: 160, width: self.view.frame.size.width, height: 400)
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
    
}

extension SelectTheatreViewController: MovieSearchControllerDelegate {
  
    func didSelectTheatre(_ theatre: Theatre_R) {
        engine?.saveSelectedTheatreToDataStore(theatre)
    }
    
}

extension SelectTheatreViewController {
    
    fileprivate func setupChildMovieSearchViewController() {
        theatreSearchViewController = MovieSearchViewController(searchType: .theatres)
        theatreSearchViewController.delegate = self
        self.addChildViewController(theatreSearchViewController, frame: nil, animated: false)
    }
    
    fileprivate func setupNextButton() {
        nextButton = UIButton()
        nextButton.backgroundColor = UIColor.yellow
        nextButton.addTarget(self, action: #selector(didSelectNextButton), for: .touchUpInside)
        nextButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
    }
    
}
