
import Foundation
import UIKit

enum CreateContestStage: CGFloat {
    case selectMovies = 1
    case selectTheatre = 2
    case summary = 3
    
    static var totalStages: CGFloat {
        return self.summary.rawValue
    }
    
    var headerLabel: String {
        switch self {
        case .selectMovies:
            return "Select Movies"
        case .selectTheatre:
            return "Select Theatre"
        case .summary:
            return "Final Details"
        }
    }
    
    var messageLabel: String {
        switch self {
        case .selectMovies:
            return "Choose the list of movies that will be voted on."
        case .selectTheatre:
            return "Where will this contest take place?"
        case .summary:
            return "Please enter final details."
        }
    }
}

final class SelectMoviesViewController: UIViewController, ChildViewControllerManager {
    
    let stage = CreateContestStage.selectMovies
    var headerView: CreateContestHeaderView!
    var movieSearchViewController: MovieSearchViewController!
    var selectedMoviesCollectionViewController: DisplayMoviesCollectionViewController!
    var nextButton: UIButton!
    
    var engine: SelectMoviesLogic?
    var router:
    (SelectMoviesRoutingLogic &
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
        let engine = SelectMoviesEngine()
        let presenter = SelectMoviesPresenter()
        let router = SelectMoviesRouter()
        viewController.engine = engine
        viewController.router = router
        engine.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        self.navigationController?.isNavigationBarHidden = true
        setupHeaderView()
        setupChildSelectedMoviesViewController()
        setupSelectedMoviesCollectionViewConstraints()
        setupChildMovieSearchViewController()
        setupMovieSearchTableViewConstraints()
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
        engine?.saveSelectedMoviesToDatabase()
        router?.routeToSelectTheatre()
    }
    
    func didTapBackButton(_ sender: UIButton) {
        engine?.deleteAllObjectsInTemporaryRealm()
        router?.routeToHome()
    }
    
    deinit {
        print("Selected Movies View Controller deinit")
    }
    
}

extension SelectMoviesViewController: MovieSearchControllerDelegate {
    
    func didSelectMovie(_ movie: ContestMovie_R) {
        let request = SelectMovies.Request(movie: movie)
        engine?.saveSelectedMovie(request: request)
    }
    
    func didDeselectMovie(_ movie: ContestMovie_R) {
        self.removeMovieFromSelectedList(movieID: movie.movieID)
    }
    
    func removeMovieFromSelectedList(movieID: String) {
        let request = SelectMovies.RemoveSelectedMovie.Request(movieID: movieID)
        engine?.removeSelectedMovie(request: request)
    }
    
    func displaySelectedMovies(viewModel: SelectMovies.ViewModel) {
        self.selectedMoviesCollectionViewController.collectionView.isHidden =
            viewModel.displayedMovies.isEmpty ? true : false
        self.nextButton.isHidden = viewModel.displayedMovies.isEmpty ? true : false
        self.selectedMoviesCollectionViewController.displayedMovies = viewModel.displayedMovies
        self.selectedMoviesCollectionViewController.collectionView.reloadData()
    }
    
}

extension SelectMoviesViewController: DisplayMoviesCollectionViewControllerDelegate {
    
    func didSelectMovie(_ movie: DisplayedMovie, at index: Int) {
        let alertInfo = SelectMovies.Alert.removeSelectedMovie(movie.title)
        let alertVC = CustomAlertViewController(alertInfo: alertInfo, okAction: {
            self.removeMovieFromSelectedList(movieID: movie.id)
        }, cancelAction: nil)
        alertVC.modalPresentationStyle = .overCurrentContext
        self.present(alertVC, animated: true, completion: nil)
    }
    
}

extension SelectMoviesViewController {
    
    fileprivate func setupChildMovieSearchViewController() {
        movieSearchViewController = MovieSearchViewController(searchType: .contestMovies)
        movieSearchViewController.delegate = self
        self.addMovieSearch(asChildViewController: movieSearchViewController)
    }
    
    fileprivate func setupChildSelectedMoviesViewController() {
        selectedMoviesCollectionViewController = DisplayMoviesCollectionViewController(gridLayout: SelectedMoviesGridLayout())
        selectedMoviesCollectionViewController.delegate = self
        self.addSelectedMovies(asChildViewController: selectedMoviesCollectionViewController)
    }
    
    fileprivate func setupNextButton() {
        nextButton = UIButton()
        nextButton.backgroundColor = UIColor.yellow
        nextButton.addTarget(self, action: #selector(didSelectNextButton), for: .touchUpInside)
        nextButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        nextButton.isHidden = true
    }
    
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
    
    fileprivate func setupSelectedMoviesCollectionViewConstraints() {
        selectedMoviesCollectionViewController.collectionView.isHidden = true
        selectedMoviesCollectionViewController.collectionView.backgroundColor = Palette.darkGrey.color
        selectedMoviesCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        selectedMoviesCollectionViewController.view.leadingAnchor.constraint(equalTo: headerView.labelStackView.leadingAnchor).isActive = true
        selectedMoviesCollectionViewController.view.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        selectedMoviesCollectionViewController.view.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 5).isActive = true
        selectedMoviesCollectionViewController.view.heightAnchor.constraint(equalToConstant: selectedMoviesCollectionViewController.collectionViewGridLayout.itemSize.height).isActive = true
    }
    
    fileprivate func setupMovieSearchTableViewConstraints() {
        movieSearchViewController.view.translatesAutoresizingMaskIntoConstraints = false
        movieSearchViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        movieSearchViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        movieSearchViewController.view.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        movieSearchViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

}

extension SelectMoviesViewController {
    
    fileprivate func addSelectedMovies(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        view.insertSubview(viewController.view, aboveSubview: headerView)
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }
    
    fileprivate func addMovieSearch(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        view.insertSubview(viewController.view, belowSubview: headerView)
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }
    
}

