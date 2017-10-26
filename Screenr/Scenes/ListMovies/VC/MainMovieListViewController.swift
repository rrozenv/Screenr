
import Foundation
import UIKit
import Moya
import RealmSwift
import PromiseKit

// MARK: - Initialization

final class MainMovieListViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var collectionViewGridLayout: MainMovieListGridLayout!

    var interactor: MainMovieListBusinessLogic?
    var displayedMovies: [MainMovieList.ViewModel.DisplayedMovie] = []
    var router:
        (MainMovieListRoutingLogic &
         MainMovieListDataPassing &
         NSObjectProtocol)?
    
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
        //self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.red
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(didSelectSettingsButton))
        setupCollectionViewProperties()
        loadCachedMovies()
        loadMoviesFromNetwork()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupCollectionViewConstraints()
    }
    
    func didSelectSettingsButton(_ sender: UIBarButtonItem) {
        router?.routeToSettings()
    }
    
}

// MARK: - Output

extension MainMovieListViewController {

    func loadCachedMovies() {
        let request = MainMovieList.Request(location: "10016")
        interactor?.loadCachedMovies(request: request)
    }
    
    func loadMoviesFromNetwork() {
        let request = MainMovieList.Request(location: "10018")
        interactor?.loadMoviesFromNetwork(request: request)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func saveMovieToDatabase(id: String) {
        let request = MainMovieList.SaveMovie.Request(movieId: id)
        interactor?.saveMovieToDatabase(request: request)
    }
    
}

// MARK: - Presenter Input

extension MainMovieListViewController {
    
    func displayMoviesFromNetwork(viewModel: MainMovieList.ViewModel) {
        isValidMovieList(viewModel: viewModel) ? handleMoviesFetchedSuccess(viewModel: viewModel) : handleCreateMoviesFailure()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        collectionView.reloadData()
        print("Got \(String(describing: viewModel.movies?.count))")
    }
    
    func displayMoviesFromCache(viewModel: MainMovieList.ViewModel) {
        print("Got \(String(describing: viewModel.movies?.count)) from CACHE")
        handleMoviesFetchedSuccess(viewModel: viewModel)
        collectionView.reloadData()
    }
    
    fileprivate func isValidMovieList(viewModel: MainMovieList.ViewModel) -> Bool {
        return viewModel.movies != nil
    }
    
    fileprivate func handleMoviesFetchedSuccess(viewModel: MainMovieList.ViewModel) {
        displayedMovies = viewModel.movies!
    }
    
    fileprivate func handleCreateMoviesFailure() {
        showFailureAlert(title: "Oops! Couldn't fetch movies.", message: "Please check your network connection and try again.")
    }
    
}

//MARK: - Collection View Data Source

extension MainMovieListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainMovieListCell.reuseIdentifier, for: indexPath) as! MainMovieListCell
        cell.label.text = displayedMovies[indexPath.item].title
        return cell
    }
    
}

//MARK: - Collection View Delegate

extension MainMovieListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = displayedMovies[indexPath.item]
        self.saveMovieToDatabase(id: selectedMovie.id)
        if let router = router {
            router.routeToShowMovieShowtimes()
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
    
    fileprivate func setupCollectionViewProperties() {
        collectionViewGridLayout = MainMovieListGridLayout()
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: collectionViewGridLayout)
        collectionView.backgroundColor = UIColor.orange
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MainMovieListCell.self, forCellWithReuseIdentifier: MainMovieListCell.reuseIdentifier)
        self.view.addSubview(collectionView)
    }
    
}

//MARK: - View Constraints Setup

extension MainMovieListViewController {
    
    fileprivate func setupCollectionViewConstraints() {
        collectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
}

final class StoredMovie: Object {
    dynamic var id: String = ""
    dynamic var title: String = ""
    
    convenience init(id: String, title: String) {
        self.init()
        self.id = id
        self.title = title
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
