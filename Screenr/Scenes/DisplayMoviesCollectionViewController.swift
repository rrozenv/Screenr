
import Foundation
import UIKit

protocol DisplayMoviesCollectionViewControllerDelegate: class {
    func didSelectMovie(_ movie: DisplayedMovie, at index: Int)
}

final class DisplayMoviesCollectionViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var collectionViewGridLayout: UICollectionViewFlowLayout!
    var displayedMovies: [DisplayedMovie] = []
    weak var delegate: DisplayMoviesCollectionViewControllerDelegate?
    
    init(gridLayout: UICollectionViewFlowLayout)  {
        super.init(nibName: nil, bundle: nil)
        self.collectionViewGridLayout = gridLayout
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        self.setupCollectionViewProperties(with: self.collectionViewGridLayout)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupCollectionViewConstraints()
    }
    
}

extension DisplayMoviesCollectionViewController {
    
    func displaySelectedMovies(viewModel: SelectMovies.ViewModel) {
        self.displayedMovies = viewModel.displayedMovies
        self.collectionView.reloadData()
    }
    
}

extension DisplayMoviesCollectionViewController {

    fileprivate func setupCollectionViewProperties(with gridLayout: UICollectionViewFlowLayout) {
        collectionViewGridLayout = gridLayout
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: collectionViewGridLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MainMovieListCell.self, forCellWithReuseIdentifier: MainMovieListCell.reuseIdentifier)
        self.view.addSubview(collectionView)
    }
    
    fileprivate func setupCollectionViewConstraints() {
        collectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
}

extension DisplayMoviesCollectionViewController: UICollectionViewDataSource {
    
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

extension DisplayMoviesCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = self.displayedMovies[indexPath.row]
        delegate?.didSelectMovie(selectedMovie, at: indexPath.row)
    }
    
}
