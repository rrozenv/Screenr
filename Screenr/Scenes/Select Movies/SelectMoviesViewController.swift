
import Foundation
import UIKit

final class SelectMoviesViewController: UIViewController, ChildViewControllerManager {
    
    var movieSearchViewController: MovieSearchViewController!
    var collectionView: UICollectionView!
    var collectionViewGridLayout: SelectedMoviesGridLayout!
    
    var engine: SelectMoviesLogic?
    var displayedMovies: [SelectMovies.ViewModel.DisplayedMovie] = []
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
        let engine = SelectMoviesEngine()
        let presenter = SelectMoviesPresenter()
        //let router = MainMovieListRouter()
        viewController.engine = engine
        //viewController.router = router
        engine.presenter = presenter
        presenter.viewController = viewController
        //router.viewController = viewController
        //router.dataStore = interactor
    }
    
}

extension SelectMoviesViewController: MovieSearchControllerDelegate {
    
    func didSelectMovie(_ movie: Movie_R) {
        let request = SelectMovies.Request(movie: movie)
        engine?.saveSelectedMovie(request: request)
    }
    
    func displaySelectedMovies(viewModel: SelectMovies.ViewModel) {
        self.displayedMovies = viewModel.displayedMovies
        self.collectionView.reloadData()
    }
    
}

extension SelectMoviesViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        setupCollectionViewProperties()
        setupChildMovieSearchViewController()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupCollectionViewConstraints()
        movieSearchViewController.view.frame = CGRect(x: 0, y: 160, width: self.view.frame.size.width, height: 400)
    }
    
    fileprivate func setupCollectionViewProperties() {
        collectionViewGridLayout = SelectedMoviesGridLayout()
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: collectionViewGridLayout)
        collectionView.backgroundColor = UIColor.orange
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MainMovieListCell.self, forCellWithReuseIdentifier: MainMovieListCell.reuseIdentifier)
        self.view.addSubview(collectionView)
    }
    
    fileprivate func setupCollectionViewConstraints() {
        collectionView.frame = CGRect(x: 0, y: 10, width: self.view.frame.size.width, height: 150)
    }
    
    fileprivate func setupChildMovieSearchViewController() {
        movieSearchViewController = MovieSearchViewController(nibName: nil, bundle: nil)
        movieSearchViewController.delegate = self
        self.addChildViewController(movieSearchViewController, frame: nil, animated: false)
    }
    
}

extension SelectMoviesViewController: UICollectionViewDataSource {
    
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

extension SelectMoviesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
}
