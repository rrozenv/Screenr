
import Foundation
import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    enum TabButtonType {
        case mainMovieList
        case contests
    }
    
    fileprivate var currentViewController: UIViewController!
    fileprivate var currentTabButton: TabButtonType {
        didSet {
            tabBarView.didSelect(tabButtonType: currentTabButton)
        }
    }
    
    fileprivate var backgroundViewForStatusBar: UIView!
    fileprivate var customNavBar: CustomNavigationBar!
    fileprivate var tabBarView: TabBarView!
    
    fileprivate lazy var mainMovieListViewController: MainMovieListViewController = {
        return MainMovieListViewController()
    }()
    
    fileprivate lazy var contestsViewController: ListContestsViewController = {
        return ListContestsViewController()
    }()
    
    var router: (HomeRoutingLogic & NSObjectProtocol)?
    
    init(currentTabButton: HomeViewController.TabButtonType) {
        self.currentTabButton = currentTabButton
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let viewController = self
        let router = HomeRouter()
        viewController.router = router
        router.viewController = viewController
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = true
        setupBackgroundViewForStatusBar()
        setupCustomNavigationBar()
        setupTabBarView()
        setCurrentViewController()
        setupNavigationButtons()
        fetchUsersCurrentLocation()
        addLocationChangedNotificationObserver()
    }
    
    fileprivate func setCurrentViewController() {
        switch currentTabButton {
        case .mainMovieList:
            currentViewController = mainMovieListViewController
        case .contests:
            currentViewController = contestsViewController
        }
        self.add(asChildViewController: currentViewController)
    }
 
}

//MARK: - Location Functions

extension HomeViewController: LocationServiceDelegate {
    
    fileprivate func fetchUsersCurrentLocation() {
        //tracingLocation(currentLocation:) will be called after inital location is found
        LocationService.shared.delegate = self
    }
    
    func tracingLocation(currentLocation: CLLocation) {
        fetchPostalCodeAndRequestMovies(location: currentLocation)
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        if let lastLocation = LocationService.shared.lastLocation {
            fetchPostalCodeAndRequestMovies(location: lastLocation)
        }
        print("Fetching location failed: \(error.localizedDescription)")
    }
    
    func fetchPostalCodeAndRequestMovies(location: CLLocation) {
        LocationService.shared
            .fetchPostalCodeFor(location)
            .then { [weak self] (postalCode) -> Void in
                guard let postalCode = postalCode else { return }
                self?.saveCurrentLocationToDefaults(location: postalCode)
                self?.displayUpdatedLocation(location: postalCode)
                NotificationCenter.default.post(name: .locationChanged, object: nil)
                print("Fetched zip: \(String(describing: postalCode))")
            }
            .catch { (error) in
                print(error.localizedDescription)
            }
    }
    
    fileprivate func addLocationChangedNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidChange), name: .locationChanged, object: nil)
    }
    
    @objc fileprivate func locationDidChange() {
        if let location = DefaultsProperty<String>.init(.currentLocation).value {
            self.displayUpdatedLocation(location: location)
        }
    }
    
    func displayUpdatedLocation(location: String) {
        self.customNavBar.locationLabel.text = "\(location)"
    }
    
    fileprivate func saveCurrentLocationToDefaults(location: String) {
        DefaultsProperty<String>(.currentLocation).value = location
    }
    
}

//MARK: - Tab Bar Item Selected Functions

extension HomeViewController {
    
    fileprivate func setupNavigationButtons() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(didSelectSettingsButton))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "No Location", style: .plain, target: self, action: #selector(self.didSelectPostalCode))
    }
    
    @objc fileprivate func didSelectLeftButton(_ sender: UIButton) {
        guard currentTabButton != .mainMovieList else { return }
        self.currentTabButton = .mainMovieList
        self.switchViewController(for: self.currentTabButton)
    }
    
    @objc fileprivate func didSelectRightButton(_ sender: UIButton) {
        guard currentTabButton != .contests else { return }
        self.currentTabButton = .contests
        self.switchViewController(for: self.currentTabButton)
    }
    
    func didSelectSettingsButton(_ sender: UIBarButtonItem) {
        router?.routeToSettings()
    }
    
    func didSelectPostalCode(_ sender: UIBarButtonItem) {
        router?.routeToLocationSearch()
    }
    
}

//MARK: - Switch View Controller Functions

extension HomeViewController {
    
    fileprivate func switchViewController(for tabBarItem: TabButtonType) {
        switch tabBarItem {
        case .mainMovieList:
            switchTo(mainMovieListViewController)
        case .contests:
            switchTo(contestsViewController)
        }
    }
    
    fileprivate func switchTo(_ viewController: UIViewController) {
        guard let currentViewController = self.currentViewController else { return }
        self.remove(asChildViewController: currentViewController)
        self.add(asChildViewController: viewController)
    }
    
    fileprivate func add(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        view.insertSubview(viewController.view, belowSubview: tabBarView)
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.constrainEdges(to: self.view)
    }
    
    fileprivate func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
}

//MARK: - View Setup

extension HomeViewController {
    
    func setupBackgroundViewForStatusBar() {
        backgroundViewForStatusBar = UIView()
        backgroundViewForStatusBar.backgroundColor = UIColor.white
        
        view.addSubview(backgroundViewForStatusBar)
        backgroundViewForStatusBar.translatesAutoresizingMaskIntoConstraints = false
        backgroundViewForStatusBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundViewForStatusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundViewForStatusBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundViewForStatusBar.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupCustomNavigationBar() {
        customNavBar = CustomNavigationBar(leftImage: #imageLiteral(resourceName: "IC_Search"), centerImage: #imageLiteral(resourceName: "IC_ClapBoard"), rightImage: #imageLiteral(resourceName: "IC_Profile"))
        
        view.insertSubview(customNavBar, belowSubview: backgroundViewForStatusBar)
        customNavBar.translatesAutoresizingMaskIntoConstraints = false
        customNavBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        customNavBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.112).isActive = true
    }
    
    func setupTabBarView() {
        tabBarView = TabBarView(leftTitle: "In Theatres", rightTitle: "Contests")
        tabBarView.didSelect(tabButtonType: currentTabButton)
        tabBarView.leftButton.addTarget(self, action: #selector(didSelectLeftButton), for: .touchUpInside)
        tabBarView.rightButton.addTarget(self, action: #selector(didSelectRightButton), for: .touchUpInside)
        
        view.insertSubview(tabBarView, belowSubview: customNavBar)
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        tabBarView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabBarView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: 2).isActive = true
//        if #available(iOS 11, *) {
//            let guide = view.safeAreaLayoutGuide
//            tabBarView.topAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
//        } else {
//            tabBarView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
//        }
        tabBarView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
}



