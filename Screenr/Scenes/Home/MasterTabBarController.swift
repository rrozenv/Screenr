

import Foundation
import UIKit
import CoreLocation

class MasterTabBarController: UIViewController {
    
    enum TabButtonType {
        case mainMovieList
        case contests
    }
    
    fileprivate var currentViewController: UIViewController!
    fileprivate var currentTabButton: TabButtonType
    fileprivate var tabBarView: TabBarView!
    
    fileprivate lazy var mainMovieListViewController: MainMovieListViewController = {
        return MainMovieListViewController()
    }()
    
    fileprivate lazy var contestsViewController: MovieSearchViewController = {
        return MovieSearchViewController(searchType: .contestMovies)
    }()
    
    var router:
        (HomeRoutingLogic &
         NSObjectProtocol)?
    
    
    init(currentTabButton: MasterTabBarController.TabButtonType) {
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
        setupTabBarView()
        setCurrentViewController()
        setupNavigationButtons()
        fetchUsersCurrentLocation()
        addLocationChangedNotificationObserver()
    }
    
    func addLocationChangedNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidChange), name: .locationChanged, object: nil)
    }
    
    func locationDidChange() {
        if let location = DefaultsProperty<String>.init(.currentLocation).value {
            self.displayUpdatedLocation(location: location)
        }
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

extension MasterTabBarController: LocationServiceDelegate {
    
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
    
    func displayUpdatedLocation(location: String) {
        self.navigationItem.leftBarButtonItem?.title = "\(location)"
    }
    
    fileprivate func saveCurrentLocationToDefaults(location: String) {
        DefaultsProperty<String>(.currentLocation).value = location
    }
    
}

extension MasterTabBarController {
    
    fileprivate func setupNavigationButtons() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(didSelectSettingsButton))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "No Location", style: .plain, target: self, action: #selector(self.didSelectPostalCode))
    }
    
    func didSelectSettingsButton(_ sender: UIBarButtonItem) {
        router?.routeToSettings()
    }
    
    func didSelectPostalCode(_ sender: UIBarButtonItem) {
        router?.routeToLocationSearch()
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
    
}

extension MasterTabBarController {
    
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

extension MasterTabBarController {
    
    func setupTabBarView() {
        tabBarView = TabBarView(leftTitle: "In Theatres", rightTitle: "Contests")
        tabBarView.leftButton.addTarget(self, action: #selector(didSelectLeftButton), for: .touchUpInside)
        tabBarView.rightButton.addTarget(self, action: #selector(didSelectRightButton), for: .touchUpInside)
        
        view.addSubview(tabBarView)
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        tabBarView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabBarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
//        if #available(iOS 11, *) {
//            let guide = view.safeAreaLayoutGuide
//            tabBarView.topAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
//        } else {
//            tabBarView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
//        }
        tabBarView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
}



