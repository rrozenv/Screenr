

import Foundation
import UIKit

class MasterTabBarController: UIViewController {
    
    enum TabButtonType {
        case mainMovieList
        case contests
    }
    
    fileprivate var currentViewController: UIViewController!
    fileprivate var currentTabButton: TabButtonType
    fileprivate var tabBarView: TabBarView!
    
    fileprivate lazy var mainMovieListViewController: UINavigationController = {
        return UINavigationController(rootViewController: MainMovieListViewController())
    }()
    
    fileprivate lazy var contestsViewController: MovieSearchViewController = {
        return MovieSearchViewController(searchType: .contestMovies)
    }()
    
    init(currentTabButton: MasterTabBarController.TabButtonType) {
        self.currentTabButton = currentTabButton
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        setupTabBarView()
        setCurrentViewController()
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

extension MasterTabBarController {
    
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
    
    fileprivate func add(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.bottomAnchor.constraint(equalTo: tabBarView.topAnchor).isActive = true
        viewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewController.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        viewController.didMove(toParentViewController: self)
    }
    
    fileprivate func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    private func switchTo(_ viewController: UIViewController) {
        guard let currentViewController = self.currentViewController else { return }
        self.remove(asChildViewController: currentViewController)
        self.add(asChildViewController: viewController)
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
        tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tabBarView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
}



