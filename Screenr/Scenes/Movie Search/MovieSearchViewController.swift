
import Foundation
import UIKit

enum SearchType {
    case movies
    case contestMovies
    case theatres
}

@objc protocol MovieSearchControllerDelegate: class {
    @objc optional func didSelectMovie(_ movie: ContestMovie_R)
    @objc optional func didSelectTheatre(_ theatre: Theatre_R)
}

final class MovieSearchViewController: UIViewController {
    
    var searchType: SearchType
    var searchTextField: SearchTextField!
    var tableView: UITableView!
    
    var displayedMovies = [MoviesSearch.ContestMovies.ViewModel.DisplayedMovie]()
    var displayedTheatres = [MoviesSearch.Theatres.ViewModel.DisplayedTheatre]()
    
    var engine: MovieSearchLogic?
    weak var delegate: MovieSearchControllerDelegate?
    
    init(searchType: SearchType) {
        self.searchType = searchType
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let engine = MovieSearchEngine()
        let presenter = MovieSearchPresenter()
        viewController.engine = engine
        engine.presenter = presenter
        presenter.viewController = viewController
    }

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.red
        setupTableView()
        setupSearchTextfield()
        setupSearchTextFieldCallback()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        searchTextField.frame = CGRect(x: 20, y: 40, width: self.view.frame.size.width * 0.8, height: 70)
        tableView.frame = CGRect(x: 0, y: 50, width: self.view.frame.size.width, height: self.view.frame.size.height - 50)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Output
    
    func createRequestWithSearch(query: String) {
        let request = MoviesSearch.ContestMovies.Request(query: query)
        engine?.makeQuery(request: request)
    }
    
    fileprivate func setupSearchTextFieldCallback() {
        searchTextField.onSearch = { searchText in
            let shouldNotSearch = (0...3).contains(searchText.count)
            //let shouldNotSearch = 0...3 ~= searchText.characters.count
            switch self.searchType {
            case .movies:
                if shouldNotSearch {
                    self.displayedMovies = [DisplayedMovieInSearch]()
                    self.tableView.reloadData()
                } else {
                    self.createRequestWithSearch(query: searchText)
                }
            case .contestMovies:
                if shouldNotSearch {
                    self.displayedMovies = [DisplayedMovieInSearch]()
                    self.tableView.reloadData()
                } else {
                    self.createRequestWithSearch(query: searchText)
                }
            case .theatres:
                if shouldNotSearch {
                    let theatre = [MoviesSearch.Theatres.ViewModel.DisplayedTheatre(id: "testId", name: "TEST THETRE AMC 25")]
                    self.displayedTheatres = theatre
                    self.tableView.reloadData()
                }
//                else {
//                    self.createRequestWithSearch(query: searchText)
//                }
            }
        }
    }
    
    //MARK: Input
    
    func displayMovies(viewModel: MoviesSearch.ContestMovies.ViewModel) {
        self.displayedMovies = viewModel.displayedMovies
        self.tableView.reloadData()
    }

}

extension MovieSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchType {
        case .contestMovies:
            return displayedMovies.count
        case .movies:
            return displayedMovies.count
        case .theatres:
            return displayedTheatres.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch searchType {
        case .movies, .contestMovies:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DisplayedMovieSearchCell.reuseIdentifier, for: indexPath) as? DisplayedMovieSearchCell else { fatalError("Unexpected Table View Cell") }
            let displayedMovie = self.displayedMovies[indexPath.row]
            cell.configure(with: displayedMovie)
            return cell
        case .theatres:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DisplayedTheatreSearchCell.reuseIdentifier, for: indexPath) as? DisplayedTheatreSearchCell else { fatalError("Unexpected Table View Cell") }
            let displayedTheatre = self.displayedTheatres[indexPath.row]
            cell.configure(with: displayedTheatre)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch searchType {
        case .movies, .contestMovies:
            guard let movie = engine?.getMovieAtIndex(indexPath.row) else { print("No movie at index: \(indexPath.row)"); return }
            delegate?.didSelectMovie?(movie)
        case .theatres:
            let displayedTheatre = self.displayedTheatres[indexPath.row]
            let theatre = Theatre_R(theatreID: displayedTheatre.id, name: displayedTheatre.name)
            delegate?.didSelectTheatre?(theatre)
            print("Theatre was selected")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}

extension MovieSearchViewController {
    
    fileprivate func setupTableView() {
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(DisplayedMovieSearchCell.self, forCellReuseIdentifier: DisplayedMovieSearchCell.reuseIdentifier)
        tableView.register(DisplayedTheatreSearchCell.self, forCellReuseIdentifier: DisplayedTheatreSearchCell.reuseIdentifier)
        tableView.keyboardDismissMode = .interactive
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    fileprivate func setupSearchTextfield() {
        searchTextField = SearchTextField()
        searchTextField.throttlingInterval = 0.5
        searchTextField.placeholder = "Email"
        searchTextField.backgroundColor = UIColor.gray
        searchTextField.layer.cornerRadius = 4.0
        searchTextField.layer.masksToBounds = true
        searchTextField.font = UIFont(name: "Avenir-Medium", size: 14.0)
        searchTextField.textColor = UIColor.black
        self.view.addSubview(searchTextField)
    }

}

