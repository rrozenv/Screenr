
import UIKit

class CalendarDayCollectionViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var collectionViewGridLayout: CalendarDaysGridLayout!
    var displayedDates: [DisplayedDate]?
    var displayedDatesStates: [Bool]!
    
    var engine: CalendarDaysBusinessLogic?
    var didSelectDate: ((String) -> ())?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let viewController = self
        let engine = CalendarDaysEngine()
        let presenter = CalendarDaysPresenter()
        viewController.engine = engine
        engine.presenter = presenter
        presenter.viewController = viewController
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewProperties()
        getCalanderDays()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupCollectionViewConstraints()
    }
    
    fileprivate func getCalanderDays() {
        let request = CalendarDays.GetCalanderDays.Request()
        engine?.getCalendarDays(request: request)
    }
    
    func displayCalendarDays(viewModel: CalendarDays.GetCalanderDays.ViewModel) {
        self.displayedDates = viewModel.displayedDates
        self.displayedDatesStates = Array(repeating: false, count: viewModel.displayedDates.count)
        self.displayedDatesStates[0] = true
        self.collectionView!.reloadData()
    }

}

extension CalendarDayCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard displayedDates != nil else { return 0 }
        return displayedDates!.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarDayCell.reuseIdentifier, for: indexPath) as! CalendarDayCell
        let displayedDate = self.displayedDates![indexPath.row]
        let selectedState = self.displayedDatesStates[indexPath.row]
        cell.configure(with: displayedDate, isSelected: selectedState)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard self.displayedDatesStates[indexPath.item] == false else { return }
        self.deselectPreviousCell()
        self.displayedDatesStates[indexPath.item] = true
        collectionView.reloadItems(at: [indexPath])
        let selectedDate = self.displayedDates![indexPath.item]
        self.didSelectDate?(selectedDate.fullDateString)
    }
    
    private func deselectPreviousCell() {
        if let previousIndex = self.displayedDatesStates.index(where: { $0 }) {
            self.displayedDatesStates[previousIndex] = false
            let previousIndexPath = IndexPath(row: previousIndex, section: 0)
            collectionView!.reloadItems(at: [previousIndexPath])
        }
    }
    
}

extension CalendarDayCollectionViewController {
    
    fileprivate func setupCollectionViewProperties() {
        collectionViewGridLayout = CalendarDaysGridLayout()
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: collectionViewGridLayout)
        collectionView.backgroundColor = UIColor.orange
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CalendarDayCell.self, forCellWithReuseIdentifier: CalendarDayCell.reuseIdentifier)
        self.view.addSubview(collectionView)
    }
    
}

extension CalendarDayCollectionViewController {
    
    func setupCollectionViewConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

}
