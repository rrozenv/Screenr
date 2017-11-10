
import Foundation
import UIKit
import RealmSwift

final class ListShowTimesViewController: UIViewController, ChildViewControllerManager {
    
    var movieHeaderView = MovieHeaderView()
    var calendarDaysCollectionViewController: CalendarDayCollectionViewController!
    var tableView: UITableView!
    var displayedTheatres: [DisplayedTheatre]!
    
    var router: (NSObjectProtocol & ListShowtimesDataPassing & ListShowtimesRoutingLogic)?
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
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.red
        setupTableView()
        setupChildCalendarDaysCollectionViewController()
        setupDidSelectCalendarDateCallback()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupMovieHeaderViewConstraints()
        setupCalendarCollectionViewConstraints()
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMovieShowtimesForCurrentDate()
        movieHeaderView.titleLabel.text = engine?.movieTitle.uppercased()
        setTableViewContentInset()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
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
    
    func didTapBackButton(_ sender: UIButton) {
        router?.routeToHome()
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
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
    }
    
    fileprivate func setTableViewContentInset() {
        let toppInset = movieHeaderView.height + calendarDaysCollectionViewController.collectionViewGridLayout.itemSize.height
        tableView.contentInset = UIEdgeInsetsMake(toppInset, 0, 0, 0)
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

extension ListShowTimesViewController {
    
    fileprivate func setupMovieHeaderViewConstraints() {
        movieHeaderView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        self.view.addSubview(movieHeaderView)
        movieHeaderView.translatesAutoresizingMaskIntoConstraints = false
        movieHeaderView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        movieHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        movieHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        movieHeaderView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.23).isActive = true
    }
    
    fileprivate func setupCalendarCollectionViewConstraints() {
        calendarDaysCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        calendarDaysCollectionViewController.view.topAnchor.constraint(equalTo: self.movieHeaderView.bottomAnchor).isActive = true
        calendarDaysCollectionViewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        calendarDaysCollectionViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        calendarDaysCollectionViewController.view.heightAnchor.constraint(equalToConstant: calendarDaysCollectionViewController.collectionViewGridLayout.itemSize.height).isActive = true
    }
    
}

final class MovieHeaderView: UIView {
    
    private let height1X: CGFloat = 154.0
    var containerView: UIView!
    var backButton: UIButton!
    var titleLabel: UILabel!
    var height: CGFloat {
        return Screen.height * (height1X / Screen.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.clear
        setupContainerView()
        setupBackButton()
        setupTitleLabel()
    }
    
    fileprivate func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.constrainEdges(to: self)
    }
    
    fileprivate func setupBackButton() {
        backButton = UIButton()
        backButton.backgroundColor = UIColor.red
        
        containerView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.053).isActive = true
        backButton.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.043).isActive = true
        backButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 22).isActive = true
        backButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
    }
    
    fileprivate func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.font = FontBook.AvenirHeavy.of(size: 13)
        titleLabel.textColor = UIColor.white
        
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
    }
    
}

