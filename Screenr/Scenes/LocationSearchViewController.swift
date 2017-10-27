
import Foundation
import UIKit

final class LocationSearchViewController: UIViewController {
    
    var tableView: UITableView!
    var displayedLocations: [LocationSearch.ViewModel.DisplayedLocation]!
    
    //var router: (NSObjectProtocol & ListShowtimesDataPassing)?
    var engine: LocationSearchLogic?
    
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
        tableView.register(TheatreTableViewCell.self, forCellReuseIdentifier: TheatreTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(tableView)
    }
    
}

extension LocationSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedLocations.isEmpty ? 0 : displayedLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        let displayedLocation = self.displayedLocations[indexPath.row]
        cell.textLabel?.text = displayedLocation.zipCode
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedTheatre = self.displayedTheatres[indexPath.row]
//        let theatre = Theatre_R(theatreID: selectedTheatre.theatreID, name: selectedTheatre.name)
//        let realm = try! Realm(configuration: RealmConfig.secret.configuration)
//        try! realm.write {
//            realm.add(theatre)
//        }
//    }
    
}
