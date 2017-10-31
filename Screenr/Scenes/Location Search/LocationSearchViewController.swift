
import Foundation
import UIKit

final class LocationSearchViewController: UIViewController {
    
    var tableView: UITableView!
    var displayedLocations = [LocationSearch.DisplayedLocation]()
    var displayedLocationStates: [Bool]!
    
    var router: (LocationSearchRoutingLogic &
                LocationSearchDataPassing &
                NSObjectProtocol)?
    
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
        let router = LocationSearchRouter()
        viewController.engine = engine
        viewController.router = router
        engine.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = engine
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.red
        setupTableView()
        fetchSavedLocations()
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
        self.displayedLocationStates = Array(repeating: false, count: viewModel.displayedLocations.count)
        if let currentLocation = UserDefaults.standard.object(forKey: "usersLocation") as? String {
            if let index = viewModel.displayedLocations.index(where: { $0.zipCode == currentLocation }) {
                self.displayedLocationStates[index] = true
            }
        }
        self.tableView.reloadData()
    }
    
    func displayDidChangeLocationConfirmation(viewModel: LocationSearch.SaveLocation.ViewModel) {
        self.showConfirmationAlert(title: "Location Changed", message: "You successfully changed your preffered zip code to: \(viewModel.displayedLocation.zipCode)")
    }
    
    fileprivate func showConfirmationAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "OK", style: .default) { [weak self] _ in
            self?.router?.routeToMainMovieList()
        }
        alertController.addAction(alertAction)
        self.showDetailViewController(alertController, sender: nil)
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
        searchController.searchBar.delegate = self
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

extension LocationSearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isSearching() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request = LocationSearch.SaveLocation.Request(zipCode: searchBar.text!)
        engine?.didSelectLocation(request: request)
    }
    
}

extension LocationSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        var displayedLocation: LocationSearch.DisplayedLocation
        let isSelected = self.displayedLocationStates[indexPath.row]
        cell.accessoryType = isSelected ? .checkmark : .none
        displayedLocation = self.displayedLocations[indexPath.row]
        cell.textLabel?.text = displayedLocation.zipCode
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let zipcode = cell?.textLabel?.text else { return }
        self.deselectPreviousCell()
        let request = LocationSearch.SaveLocation.Request(zipCode: zipcode)
        engine?.didSelectLocation(request: request)
    }
    
    private func deselectPreviousCell() {
        if let previousIndex = self.displayedLocationStates.index(where: { $0 }) {
            self.displayedLocationStates[previousIndex] = false
            let previousIndexPath = IndexPath(row: previousIndex, section: 0)
            tableView.reloadRows(at: [previousIndexPath], with: .none)
        }
    }
    
}
