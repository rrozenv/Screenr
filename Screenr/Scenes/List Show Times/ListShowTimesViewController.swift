
import Foundation
import UIKit
import RealmSwift

final class ListShowTimesViewController: UIViewController, ChildViewControllerManager {
    
    var movieHeaderView = MovieHeaderView()
    var smallMovieHeaderView = SmallMovieHeaderView()
    var calendarDaysCollectionViewController: CalendarDayCollectionViewController!
    
    var tableView: UITableView!
    var displayedTheatres: [DisplayedTheatre]!
    var contentOffset: CGFloat = 0
    
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
       
        setupMovieHeaderViewConstraints()
        
        setupChildCalendarDaysCollectionViewController()
        setupCalendarCollectionViewConstraints()
        setupDidSelectCalendarDateCallback()
        
        setupTableView()
        setupTableViewConstraints()
        
        setupSmallMovieHeaderViewConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMovieShowtimesForCurrentDate()
        movieHeaderView.titleLabel.text = engine?.movieTitle.uppercased()
        smallMovieHeaderView.titleLabel.text = engine?.movieTitle.uppercased()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
}

extension ListShowTimesViewController {
    
    //MARK: Output
    func getMovieShowtimesForCurrentDate() {
        //Movie object passed from MainMovieListVC contains showtimes for current date
        let request = ListShowtimes.GetShowtimes.Request(location: nil, date: nil)
        engine?.getMovieShowtimes(request: request)
    }
    
    func getMovieShowtimesFor(date: String) {
        if let location = DefaultsProperty<String>(.currentLocation).value {
            let request = ListShowtimes.GetShowtimes.Request(location: location, date: date)
            engine?.getMovieShowtimes(request: request)
        } else {
            //TODO: Can't get location
        }
    }
    
    func setupDidSelectCalendarDateCallback() {
        self.calendarDaysCollectionViewController.didSelectDate = { [weak self] (date) in
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
      
    }
    
}

extension ListShowTimesViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.contentOffset = self.tableView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPosition = self.tableView.contentOffset.y
        print("SCROLL POS: \(scrollPosition)")
        print("CONTENT OFF: \(self.contentOffset)")
        if scrollPosition > self.contentOffset {
            UIView.animate(withDuration: 0.7, animations: {
                self.calendarDaysCollectionViewController.view.alpha = 0
                self.movieHeaderView.alpha = 0
                self.smallMovieHeaderView.isHidden = false
                self.smallMovieHeaderView.alpha = 1
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.7, animations: {
                self.calendarDaysCollectionViewController.view.alpha = 1
                self.movieHeaderView.alpha = 1
                self.smallMovieHeaderView.alpha = 0
            }, completion: nil)
        }
    }
    
}

extension ListShowTimesViewController {
    
    fileprivate func setupTableView() {
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(TheatreTableViewCell.self, forCellReuseIdentifier: TheatreTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        let toppInset = movieHeaderView.height + calendarDaysCollectionViewController.collectionViewGridLayout.itemSize.height
        tableView.contentInset = UIEdgeInsetsMake(toppInset, 0, 20, 0)
    }
    
    fileprivate func setupChildCalendarDaysCollectionViewController() {
        calendarDaysCollectionViewController = CalendarDayCollectionViewController(numberOfDays: 14)
        self.addChildViewController(calendarDaysCollectionViewController, frame: nil, animated: false)
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
    
    fileprivate func setupTableViewConstraints() {
        self.view.insertSubview(tableView, belowSubview: movieHeaderView)
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    fileprivate func setupSmallMovieHeaderViewConstraints() {
        smallMovieHeaderView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        smallMovieHeaderView.isHidden = true
        
        self.view.addSubview(smallMovieHeaderView)
        smallMovieHeaderView.translatesAutoresizingMaskIntoConstraints = false
        smallMovieHeaderView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        smallMovieHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        smallMovieHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        smallMovieHeaderView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
    }
    
}


