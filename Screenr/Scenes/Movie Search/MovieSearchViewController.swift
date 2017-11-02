
import Foundation
import UIKit

final class MovieSearchViewController: UIViewController {
    
    var searchTextField: SearchTextField!
    var tableView: UITableView!
    var displayedMovies = [MoviesSearch.ViewModel.DisplayedMovie]()
//    var displayedLocationStates: [Bool]!
    
    var engine: MovieSearchLogic?
//    let searchController = UISearchController(searchResultsController: nil)
//
//    var router: (LocationSearchRoutingLogic &
//    LocationSearchDataPassing &
//    NSObjectProtocol)?
//
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let engine = MovieSearchEngine()
        let presenter = MovieSearchPresenter()
        //let router = LocationSearchRouter()
        viewController.engine = engine
        //viewController.router = router
        engine.presenter = presenter
        presenter.viewController = viewController
//        router.viewController = viewController
//        router.dataStore = engine
    }

//    // MARK: - View Life Cycle
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
        let request = MoviesSearch.Request(query: query)
        engine?.makeQuery(request: request)
    }
    
    fileprivate func setupSearchTextFieldCallback() {
        searchTextField.onSearch = { searchText in
            if searchText.characters.count == 0 {
                self.displayedMovies = [DisplayedMovieInSearch]()
                self.tableView.reloadData()
            } else if searchText.characters.count >= 3 {
                self.createRequestWithSearch(query: searchText)
            }
        }
    }
    
    //MARK: Input
    func displayMovies(viewModel: MoviesSearch.ViewModel) {
        self.displayedMovies = viewModel.displayedMovies
        self.tableView.reloadData()
    }

}

//extension MovieSearchViewController: UITextFieldDelegate {
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        guard let query = textField.text else { return false }
//        self.createRequestWithSearch(query: query)
//        return true
//    }
//
//}

extension MovieSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DisplayedMovieSearchCell.reuseIdentifier, for: indexPath) as? DisplayedMovieSearchCell else { fatalError("Unexpected Table View Cell") }
        let displayedMovie = self.displayedMovies[indexPath.row]
        cell.configure(with: displayedMovie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}

extension MovieSearchViewController {
    
    fileprivate func setupTableView() {
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(DisplayedMovieSearchCell.self, forCellReuseIdentifier: DisplayedMovieSearchCell.reuseIdentifier)
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

