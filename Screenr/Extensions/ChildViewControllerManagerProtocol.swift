
import Foundation
import UIKit

protocol ChildViewControllerManager: class {
    func addChildViewController(_ viewController: UIViewController, frame: CGRect?, animated: Bool)
    func removeChildViewController(_ viewController: UIViewController, completion: (() -> Void)?)
}

extension ChildViewControllerManager where Self: UIViewController {
    
    func addChildViewController(_ viewController: UIViewController, frame: CGRect?, animated: Bool) {
        self.addChildViewController(viewController)
        self.view.addSubview(viewController.view)
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
        if let frame = frame { viewController.view.frame = frame }
        
        guard animated else { view.alpha = 1.0; return }
        UIView.transition(with: view, duration: 0.5, options: .curveEaseIn, animations: {
            self.view.alpha = 1.0
        }) { _ in }
    }
    
    func removeChildViewController(_ viewController: UIViewController, completion: (() -> Void)?) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
        if completion != nil { completion!() }
    }
    
}

//fileprivate func add(asChildViewController viewController: UIViewController) {
//    addChildViewController(viewController)
//    view.addSubview(viewController.view)
//    viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//    viewController.view.translatesAutoresizingMaskIntoConstraints = false
//    viewController.view.bottomAnchor.constraint(equalTo: tabBarView.topAnchor).isActive = true
//    viewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//    viewController.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//    viewController.didMove(toParentViewController: self)
//}
//
//fileprivate func remove(asChildViewController viewController: UIViewController) {
//    viewController.willMove(toParentViewController: nil)
//    viewController.view.removeFromSuperview()
//    viewController.removeFromParentViewController()
//}

