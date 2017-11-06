
import Foundation
import UIKit
import Moya
import RealmSwift
import PromiseKit

// MARK: - Initialization

final class MainMovieListViewController: UIViewController, ChildViewControllerManager {
    
    var moviesCollectionViewController: DisplayMoviesCollectionViewController!
    var movieSearchButton: UIButton!

    var interactor: MainMovieListBusinessLogic?
    var router:
        (MainMovieListRoutingLogic &
         MainMovieListDataPassing &
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
  
}

// MARK: - View Life Cycle

extension MainMovieListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        setupNavigationButtons()
        setupChildSelectedMoviesViewController()
        setupMovieSearchButtonProperties()
        loadCachedMovies()
        fetchUsersCurrentLocation()
    }
    
    fileprivate func setupNavigationButtons() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(didSelectSettingsButton))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "No Location", style: .plain, target: self, action: #selector(self.didSelectPostalCode))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard locationDidChange else { return }
        if let location =  DefaultsProperty<String>.init(.currentLocation).value {
            self.loadMoviesFromNetwork(for: location)
        }
        locationDidChange = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupCollectionViewConstraints()
        setupMovieSearchButtonConstrains()
    }
    
    fileprivate func setupChildSelectedMoviesViewController() {
        moviesCollectionViewController = DisplayMoviesCollectionViewController(gridLayout: MainMovieListGridLayout())
        moviesCollectionViewController.delegate = self
        self.addChildViewController(moviesCollectionViewController, frame: nil, animated: false)
    }
    
    func didSelectSettingsButton(_ sender: UIBarButtonItem) {
        router?.routeToSettings()
    }
    
    func didSelectPostalCode(_ sender: UIBarButtonItem) {
        print("Postal Code Selected")
        router?.routeToLocationSearch()
    }
    
    func didSelectMovieSearchButton(_ sender: UIButton) {
        router?.routeToMovieSearch()
    }
    
}

extension MainMovieListViewController: LocationServiceDelegate {
    
    fileprivate func fetchUsersCurrentLocation() {
        //tracingLocation(currentLocation:) will be called after inital location is found
        LocationService.shared.delegate = self
    }
    
    func tracingLocation(currentLocation: CLLocation) {
        fetchPostalCodeAndRequestMovies(location: currentLocation)
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        if let lastLocation = LocationService.shared.lastLocation {
            fetchPostalCodeAndRequestMovies(location: lastLocation)
        }
        print("Fetching location failed: \(error.localizedDescription)")
    }
    
    func fetchPostalCodeAndRequestMovies(location: CLLocation) {
        LocationService.shared
            .fetchPostalCodeFor(location)
            .then { [weak self] (postalCode) -> Void in
                guard let postalCode = postalCode else { return }
                self?.loadMoviesFromNetwork(for: postalCode)
                self?.displayUpdatedLocation(location: postalCode)
                print("Fetched zip: \(String(describing: postalCode))")
            }
            .catch { (error) in
                print(error.localizedDescription)
        }
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
        //displayedMovies = viewModel.movies!
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
        movieSearchButton.backgroundColor = UIColor.red
        movieSearchButton.addTarget(self, action: #selector(didSelectMovieSearchButton), for: .touchUpInside)
        self.view.addSubview(movieSearchButton)
    }
    
}

//MARK: - View Constraints Setup

extension MainMovieListViewController {
    
    fileprivate func setupCollectionViewConstraints() {
        moviesCollectionViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    fileprivate func setupMovieSearchButtonConstrains() {
        movieSearchButton.frame = CGRect(x: 0, y: 600, width: self.view.frame.size.width, height: 50)
    }
    
}
