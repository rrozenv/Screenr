
import Foundation
import UIKit

final class LocationSearchViewController: UIViewController {
    
    var tableView: UITableView!
    var displayedLocations = [LocationSearch.ViewModel.DisplayedLocation]()
    
    //var router: (NSObjectProtocol & ListShowtimesDataPassing)?
    var engine: LocationSearchLogic?
    
    let searchController = UISearchController(searchResultsController: nil)
    var didSelectLocation: ((String) -> ())?
    
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
        let engine = LocationSearchEngine()
        let presenter = LocationSearchPresenter()
        viewController.engine = engine
        //viewController.router = router
        engine.presenter = presenter
        presenter.viewController = viewController
//        router.viewController = viewController
//        router.dataStore = engine
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.red
        setupTableView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSearchController()
    }
    
    //MARK: Output
    func fetchSavedLocations() {
        engine?.fetchSavedLocations()
    }
    
    //MARK: Input
    func displaySavedLocations(viewModel: LocationSearch.ViewModel) {
        self.displayedLocations = viewModel.displayedLocations
        self.tableView.reloadData()
    }
    
    fileprivate func setupTableView() {
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LocationCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    fileprivate func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Zip Code"
        //navigationItem.searchController = searchController
        definesPresentationContext = true
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
  
    
}

extension LocationSearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isSearching() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}

extension LocationSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching() {
            return displayedLocations.count + 1
        }
        return displayedLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        var displayedLocation: LocationSearch.ViewModel.DisplayedLocation
        if isSearching() {
            if indexPath.row == 0 {
                cell.textLabel?.text = searchController.searchBar.text
            } else {
                displayedLocation = self.displayedLocations[indexPath.row - 1]
                cell.textLabel?.text = displayedLocation.zipCode
            }
        } else {
            displayedLocation = self.displayedLocations[indexPath.row]
            cell.textLabel?.text = displayedLocation.zipCode
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let text = cell?.textLabel?.text else { return }
        self.didSelectLocation?(text)
        self.dismiss(animated: true, completion: nil)
    }
    
}
