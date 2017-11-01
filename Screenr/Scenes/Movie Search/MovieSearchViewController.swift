
import Foundation
import UIKit

final class MovieSearchViewController: UIViewController {
    
    var searchTextField: UITextField!
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
        //engine.presenter = presenter
        presenter.viewController = viewController
//        router.viewController = viewController
//        router.dataStore = engine
    }

//    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.red
        setupSearchTextfield()
        setupTableView()
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
    
    //MARK: Input
    func displayMovies(viewModel: MoviesSearch.ViewModel) {
        self.displayedMovies = viewModel.displayedMovies
        self.tableView.reloadData()
    }

    fileprivate func setupTableView() {
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LocationCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }

    fileprivate func setupSearchTextfield() {
        searchTextField.delegate = self
        searchTextField.placeholder = "Email"
        searchTextField.backgroundColor = UIColor.gray
        searchTextField.layer.cornerRadius = 4.0
        searchTextField.layer.masksToBounds = true
        searchTextField.font = UIFont(name: "Avenir-Medium", size: 14.0)
        searchTextField.textColor = UIColor.black
        self.view.addSubview(searchTextField)
    }
    
}

extension MovieSearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let request = MoviesSearch.Request(query: textField.text!)
        engine?.makeQuery(request: request)
        return true
    }
    
}

//extension MovieSearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
//    
//    func updateSearchResults(for searchController: UISearchController) {
//        tableView.reloadData()
//    }
//    
//    func searchBarIsEmpty() -> Bool {
//        return searchController.searchBar.text?.isEmpty ?? true
//    }
//    
//    func isSearching() -> Bool {
//        return searchController.isActive && !searchBarIsEmpty()
//    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request = LocationSearch.SaveLocation.Request(zipCode: searchBar.text!)
//        engine?.didSelectLocation(request: request)
//    }
//    
//}
//

extension MovieSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        let displayedMovie = self.displayedMovies[indexPath.row]
        cell.textLabel?.text = displayedMovie.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

