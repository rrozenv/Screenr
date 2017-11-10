
import Foundation
import UIKit
import Moya
import RealmSwift
import PromiseKit

// MARK: - Initialization

final class MainMovieListViewController: UIViewController, ChildViewControllerManager {
    
    var collectionViewTopInset: CGFloat?
    var moviesCollectionViewController: DisplayMoviesCollectionViewController!
    var movieSearchButton: UIButton!

    var interactor: MainMovieListBusinessLogic?
    var router:
        (MainMovieListRoutingLogic &
         MainMovieListDataPassing &
         NSObjectProtocol)?
    
    var postalCodeButton: UIBarButtonItem!
    
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
        let interactor = MainMovieListInteractor()
        let presenter = MainMovieListPresenter()
        let router = MainMovieListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    deinit {
        print("Main Movie list is deiniting")
    }
  
}

// MARK: - View Life Cycle

extension MainMovieListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        setupChildSelectedMoviesViewController()
        setupMovieSearchButtonProperties()
        loadCachedMovies()
        addLocationChangedNotificationObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func addLocationChangedNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidChange), name: .locationChanged, object: nil)
    }
    
    func locationDidChange() {
        if let location = DefaultsProperty<String>.init(.currentLocation).value {
            self.loadMoviesFromNetwork(for: location)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupCollectionViewConstraints()
        setupMovieSearchButtonConstrains()
    }
    
    fileprivate func setupChildSelectedMoviesViewController() {
        var gridLayout: MainMovieListGridLayout
        if let collectionViewTopInset = collectionViewTopInset {
            gridLayout = MainMovieListGridLayout(topInset: collectionViewTopInset)
        } else {
            gridLayout = MainMovieListGridLayout(topInset: nil)
        }
        moviesCollectionViewController = DisplayMoviesCollectionViewController(gridLayout: gridLayout)
        moviesCollectionViewController.delegate = self
        self.addChildViewController(moviesCollectionViewController, frame: nil, animated: false)
    }
    
}

// MARK: - Output

extension MainMovieListViewController {
    
    func loadCachedMovies() {
        let request = MainMovieList.Request(location: nil)
        interactor?.loadCachedMovies(request: request)
    }
    
    func loadMoviesFromNetwork(for location: String) {
        interactor?.loadMoviesFromNetwork(for: location)
    }
    
    func displayUpdatedLocation(location: String) {
        self.navigationItem.leftBarButtonItem?.title = "\(location)"
    }
    
    func didSelectMovieSearchButton(_ sender: UIButton) {
        router?.routeToMovieSearch()
    }
    
}

// MARK: - Presenter Input

extension MainMovieListViewController {
    
    func displayMoviesFromNetwork(viewModel: MainMovieList.ViewModel) {
        isValidMovieList(viewModel: viewModel) ? handleMoviesFetchedSuccess(viewModel: viewModel) : handleCreateMoviesFailure()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        moviesCollectionViewController.collectionView.reloadData()
        print("Got \(String(describing: viewModel.movies?.count))")
    }
    
    fileprivate func isValidMovieList(viewModel: MainMovieList.ViewModel) -> Bool {
        return viewModel.movies != nil
    }
    
    fileprivate func handleMoviesFetchedSuccess(viewModel: MainMovieList.ViewModel) {
        moviesCollectionViewController.displayedMovies = viewModel.movies!
    }
    
    fileprivate func handleCreateMoviesFailure() {
        showFailureAlert(title: "Oops! Couldn't fetch movies.", message: "Please check your network connection and try again.")
    }
    
}


//MARK: - Collection View Delegate

extension MainMovieListViewController: DisplayMoviesCollectionViewControllerDelegate {
    
    func didSelectMovie(_ movie: DisplayedMovie, at index: Int) {
        guard let selectedMovie = interactor?.getMovieAtIndex(index) else { return }
        if let router = router {
            router.routeToShowMovieShowtimes(for: selectedMovie)
        }
    }
    
}

//MARK: - Errors

extension MainMovieListViewController {
    
    fileprivate func showFailureAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.showDetailViewController(alertController, sender: nil)
    }
    
}

//MARK: - View Properties Setup

extension MainMovieListViewController {

    fileprivate func setupMovieSearchButtonProperties() {
        movieSearchButton = UIButton()
        movieSearchButton.dropShadow()
        movieSearchButton.backgroundColor = UIColor.black
        movieSearchButton.titleLabel?.font = FontBook.AvenirHeavy.of(size: 13)
        movieSearchButton.setTitle("Create Contest", for: .normal)
        movieSearchButton.addTarget(self, action: #selector(didSelectMovieSearchButton), for: .touchUpInside)
    }
    
}

//MARK: - View Constraints Setup

extension MainMovieListViewController {
    
    fileprivate func setupCollectionViewConstraints() {
        moviesCollectionViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    fileprivate func setupMovieSearchButtonConstrains() {
        self.view.addSubview(movieSearchButton)
        movieSearchButton.translatesAutoresizingMaskIntoConstraints = false
        movieSearchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        movieSearchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        movieSearchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        movieSearchButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
}
