
import Foundation
import UIKit

extension UIView {
    func constrainEdges(to view: UIView) {
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
}

protocol CalendarDaySelectionModalViewControllerDelegate: class {
    func didSelectDate(_ date: Date)
}

final class CalendarDaySelectionModalViewController: UIViewController, ChildViewControllerManager {
    
    fileprivate var opaqueButtonView: UIButton!
    fileprivate var calendarDaysCollectionViewController: CalendarDayCollectionViewController!
    weak var delegate: CalendarDaySelectionModalViewControllerDelegate?
    var didSelectDate: ((Date) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        setupChildCalendarDaysCVControllerProperties()
        setupOpaqueViewProperties()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupChildCalendarDaysCVControllerConstraints()
        setupOpaqueViewConstraints()
        setupDidSelectCalendarDateCallback()
    }
    
    deinit {
        print("Calender Modal deinitalized.")
    }
    
    func setupDidSelectCalendarDateCallback() {
        self.calendarDaysCollectionViewController.didSelectDate = { [weak self] (date) in
            self?.delegate?.didSelectDate(date)
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    func didTapOpaqueButtonView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CalendarDaySelectionModalViewController {
    
    fileprivate func setupOpaqueViewProperties() {
        opaqueButtonView = UIButton()
        opaqueButtonView.backgroundColor = UIColor.black
        opaqueButtonView.alpha = 0.7
        opaqueButtonView.addTarget(self, action: #selector(didTapOpaqueButtonView), for: .touchUpInside)
    }
    
    fileprivate func setupChildCalendarDaysCVControllerProperties() {
        calendarDaysCollectionViewController = CalendarDayCollectionViewController(numberOfDays: 30)
        self.addChildViewController(calendarDaysCollectionViewController, frame: nil, animated: false)
    }
    
}

extension CalendarDaySelectionModalViewController {
    
    fileprivate func setupOpaqueViewConstraints() {
        self.view.insertSubview(opaqueButtonView, belowSubview: calendarDaysCollectionViewController.view)
        opaqueButtonView.translatesAutoresizingMaskIntoConstraints = false
        opaqueButtonView.constrainEdges(to: view)
    }
    
    fileprivate func setupChildCalendarDaysCVControllerConstraints() {
        //calendarDaysCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        calendarDaysCollectionViewController.view.frame = CGRect(x: 0, y: 400, width: self.view.frame.size.width, height: 150)
        //        calendarDaysCollectionViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        //        calendarDaysCollectionViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}

