
import Foundation
import UIKit
import RealmSwift

final class ListShowTimesViewController: UIViewController, ChildViewControllerManager {
    
    var calendarDaysCollectionViewController: CalendarDayCollectionViewController!
    var tableView: UITableView!
    var displayedTheatres: [DisplayedTheatre]!
    
    var router: (NSObjectProtocol & ListShowtimesDataPassing)?
    var engine: ListShowtimesBusinessLogic?
    
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
        let engine = ListShowtimesEngine()
        let presenter = ListShowtimesPresenter()
        let router = ListShowtimesRouter()
        viewController.engine = engine
        viewController.router = router
        engine.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = engine
    }
    
    deinit {
        print("DEINIT OF DETAIL VC")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.red
        setupTableView()
        setupChildCalendarDaysCollectionViewController()
        setupDidSelectCalendarDateCallback()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        calendarDaysCollectionViewController.view.frame = CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: 150)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMovieShowtimesForCurrentDate()
    }
    
    //MARK: Output
    func getMovieShowtimesForCurrentDate() {
        //Movie object passed from MainMovieListVC contains showtimes for current date
        let request = ListShowtimes.GetShowtimes.Request(location: nil, date: nil)
        engine?.getMovieShowtimes(request: request)
    }
    
    func getMovieShowtimesFor(date: String) {
        //Used to get showtimes for future dates
        let request = ListShowtimes.GetShowtimes.Request(location: "10016", date: date)
        engine?.getMovieShowtimes(request: request)
    }
    
    func setupDidSelectCalendarDateCallback() {
        self.calendarDaysCollectionViewController.didSelectDate = { [weak self] (date) in
            print("Selected date \(date.yearMonthDayString)")
            self?.getMovieShowtimesFor(date: date.yearMonthDayString)
        }
    }
    
    //MARK: Input
    func displayMovieShowtimes(viewModel: ListShowtimes.GetShowtimes.ViewModel) {
        self.displayedTheatres = viewModel.displayedTheaters
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
    
    fileprivate func setupChildCalendarDaysCollectionViewController() {
        calendarDaysCollectionViewController = CalendarDayCollectionViewController(numberOfDays: 14)
        self.addChildViewController(calendarDaysCollectionViewController, frame: nil, animated: false)
    }
    
}

extension ListShowTimesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedTheatres.isEmpty ? 0 : displayedTheatres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TheatreTableViewCell.reuseIdentifier, for: indexPath) as? TheatreTableViewCell else { fatalError("Unexpected Table View Cell") }
        let displayedTheatre = self.displayedTheatres[indexPath.row]
        cell.configure(with: displayedTheatre)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTheatre = self.displayedTheatres[indexPath.row]
        let theatre = Theatre_R(theatreID: selectedTheatre.theatreID, name: selectedTheatre.name)
        let realm = try! Realm(configuration: RealmConfig.secret.configuration)
        try! realm.write {
            realm.add(theatre)
        }
    }
    
}

