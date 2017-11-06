
import Foundation
import UIKit

final class SelectMoviesViewController: UIViewController, ChildViewControllerManager {
    
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
        setupChildSelectedMoviesViewController()
        setupChildMovieSearchViewController()
        setupNextButton()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        movieSearchViewController.view.frame = CGRect(x: 0, y: 160, width: self.view.frame.size.width, height: 400)
        selectedMoviesCollectionViewController.view.frame = CGRect(x: 0, y: 10, width: self.view.frame.size.width, height: 150)
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
    
}

extension SelectMoviesViewController: MovieSearchControllerDelegate {
    
    func didSelectMovie(_ movie: Movie_R) {
        let request = SelectMovies.Request(movie: movie)
        engine?.saveSelectedMovie(request: request)
    }
    
    func displaySelectedMovies(viewModel: SelectMovies.ViewModel) {
        self.selectedMoviesCollectionViewController.displayedMovies = viewModel.displayedMovies
        self.selectedMoviesCollectionViewController.collectionView.reloadData()
    }
    
}

extension SelectMoviesViewController {
    
    fileprivate func setupChildMovieSearchViewController() {
        movieSearchViewController = MovieSearchViewController(searchType: .movies)
        movieSearchViewController.delegate = self
        self.addChildViewController(movieSearchViewController, frame: nil, animated: false)
    }
    
    fileprivate func setupChildSelectedMoviesViewController() {
        selectedMoviesCollectionViewController = DisplayMoviesCollectionViewController(gridLayout: SelectedMoviesGridLayout())
        self.addChildViewController(selectedMoviesCollectionViewController, frame: nil, animated: false)
    }
    
    fileprivate func setupNextButton() {
        nextButton = UIButton()
        nextButton.backgroundColor = UIColor.yellow
        nextButton.addTarget(self, action: #selector(didSelectNextButton), for: .touchUpInside)
        nextButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
    }

}

