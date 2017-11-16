
import Foundation
import UIKit

final class CreateContestSummaryViewController: UIViewController, ChildViewControllerManager {
    
    lazy var calendarDaysSelectionModalVC: CalendarDaySelectionModalViewController = {
        let calendarDaysSelectionModalVC = CalendarDaySelectionModalViewController()
        calendarDaysSelectionModalVC.delegate = self
        return calendarDaysSelectionModalVC
    }()
    
    let stage = CreateContestStage.summary
    var headerView: CreateContestHeaderView!
    var tableView: UITableView!
    var selectedMoviesCollectionViewController: DisplayMoviesCollectionViewController!
    var createButton: UIButton!
    
    var engine: CreateContestSummaryEngine?
    var router:
    (CreateContestSummaryRoutingLogic &
    NSObjectProtocol)?
    
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
        let engine = CreateContestSummaryEngine()
        let presenter = CreateContestSummaryPresenter()
        let router = CreateContestSummaryRouter()
        viewController.engine = engine
        viewController.router = router
        engine.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        setupHeaderView()
        setupChildSelectedMoviesViewController()
        setupTableView()
        setupTableViewConstraints()
        setupCreateButton()
        fetchSelectedMoviesFromDatabase()
        fetchSelectedTheatreFromDatabase()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        selectedMoviesCollectionViewController.view.frame = CGRect(x: 0, y: 10, width: self.view.frame.size.width, height: 100)
        tableView.frame = CGRect(x: 0, y: 110, width: self.view.frame.size.width, height: 550)
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return createButton
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
}

//MARK: Output

extension CreateContestSummaryViewController {
    
    func didSelectCreateButton(_ sender: UIButton) {
        engine?.createContestInDatabase()
    }
    
    func fetchSelectedMoviesFromDatabase() {
        engine?.fetchSelectedMoviesFromDatabase()
    }
    
    func fetchSelectedTheatreFromDatabase() {
        engine?.fetchSelectedTheatreFromDatabase()
    }
    
    func didTapBackButton(_ sender: UIButton) {
        router?.routeToSelectTheatre()
    }
    
    @objc fileprivate func didSelectDateButton() {
        calendarDaysSelectionModalVC.modalPresentationStyle = .overCurrentContext
        self.present(self.calendarDaysSelectionModalVC, animated: true, completion: nil)
    }
    
    fileprivate func displayTextFieldAlert(for alertType: Alert) {
        let alertController = UIAlertController(title: alertType.title, message: nil, preferredStyle: .alert)
        alertController.addTextField()
        var submitAction: UIAlertAction
        switch alertType {
        case .price:
            submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alertController] _ in
                let textField = alertController.textFields![0]
                textField.keyboardType = .decimalPad
                guard let price = textField.text, price != "" else { return }
                self.engine?.updateTicketPrice(to: price)
            }
        case .votes:
            submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alertController] _ in
                let textField = alertController.textFields![0]
                textField.keyboardType = .decimalPad
                guard let voteNumber = textField.text, voteNumber != "" else { return }
                self.engine?.updateVotesRequired(to: voteNumber)
            }
        }
        alertController.addAction(submitAction)
        self.showDetailViewController(alertController, sender: nil)
    }
    
}

//MARK: Input

extension CreateContestSummaryViewController: CalendarDaySelectionModalViewControllerDelegate {
    
    func displaySelectedMovies(viewModel: SelectMovies.ViewModel) {
        self.selectedMoviesCollectionViewController.displayedMovies = viewModel.displayedMovies
        self.selectedMoviesCollectionViewController.collectionView.reloadData()
    }
    
    func displaySelectedTheatre(viewModel: CreateContestSummary.SelectedTheatre.ViewModel) {
        print("Selected theatre currently is: \(viewModel.displayedTheatre.name)")
    }
    
    func displayDidCreateContestConfirmation() {
        self.showContestCreatedConfirmation(title: "Contest Created Successfully", message: "Woo!")
    }
    
    fileprivate func showContestCreatedConfirmation(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "OK", style: .default) { [weak self] _ in
            self?.engine?.deleteAllObjectsInTemporaryRealm()
            self?.router?.routeToMainMovieList()
        }
        alertController.addAction(alertAction)
        self.showDetailViewController(alertController, sender: nil)
    }
    
    func displayUpdatedDate() {
        self.tableView.reloadRows(at: [IndexPath(row: Cell.date.rawValue, section: 0)], with: .none)
    }
    
    func displayUpdatedPrice() {
        self.tableView.reloadRows(at: [IndexPath(row: Cell.price.rawValue, section: 0)], with: .none)
    }
    
    func displayUpdatedVotesRequired() {
        self.tableView.reloadRows(at: [IndexPath(row: Cell.votes.rawValue, section: 0)], with: .none)
    }
    
    func didSelectDate(_ date: Date) {
        self.engine?.updateDate(to: date)
    }
    
}

extension CreateContestSummaryViewController: UITableViewDataSource, UITableViewDelegate {
    
    enum Cell: Int {
        case date = 0
        case price = 1
        case votes = 2
    }
    
    enum Alert {
        case price
        case votes
        
        var title: String {
            switch self {
            case .price:
                return "Price of ticket?"
            case .votes:
                return "Number of votes required?"
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = Cell.init(rawValue: indexPath.row) else { fatalError("Unexpected Table View Cell") }
        switch cellType {
        case .date:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateContestSummaryDateCell.reuseIdentifier, for: indexPath) as? CreateContestSummaryDateCell else { fatalError("Unexpected Table View Cell") }
            cell.configure(with: engine?.date.yearMonthDayString)
            cell.dateButton.addTarget(self, action: #selector(didSelectDateButton), for: .touchUpInside)
            return cell
        case .price:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as? TextFieldCell else { fatalError("Unexpected Table View Cell") }
            cell.configure(with: .price, inputValue: engine?.ticketPrice)
            return cell
        case .votes:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as? TextFieldCell else { fatalError("Unexpected Table View Cell") }
            cell.configure(with: .votes, inputValue: engine?.votesRequired)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellType = Cell.init(rawValue: indexPath.row) else { fatalError("Unexpected Table View Cell") }
        switch cellType {
        case .date:
            //Date selection handled by button in cell. See func didSelectDateButton(:_).
            break
        case .price:
            displayTextFieldAlert(for: .price)
        case .votes:
            displayTextFieldAlert(for: .votes)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
}

extension CreateContestSummaryViewController {
    
    fileprivate func setupHeaderView() {
        headerView = CreateContestHeaderView(currentStage: stage.rawValue, totalStages: CreateContestStage.totalStages)
        headerView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        headerView.headerLabel.text = stage.headerLabel
        headerView.messageLabel.text = stage.messageLabel
        
        self.view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.195).isActive = true
    }
    
    fileprivate func setupChildSelectedMoviesViewController() {
        selectedMoviesCollectionViewController = DisplayMoviesCollectionViewController(gridLayout: SelectedMoviesGridLayout())
        self.addChildViewController(selectedMoviesCollectionViewController, frame: nil, animated: false)
        selectedMoviesCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        selectedMoviesCollectionViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        selectedMoviesCollectionViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        selectedMoviesCollectionViewController.view.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        selectedMoviesCollectionViewController.view.heightAnchor.constraint(equalToConstant: selectedMoviesCollectionViewController.collectionViewGridLayout.itemSize.height).isActive = true
    }
    
    fileprivate func setupTableView() {
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.reuseIdentifier)
        tableView.register(CreateContestSummaryDateCell.self, forCellReuseIdentifier: CreateContestSummaryDateCell.reuseIdentifier)
        tableView.keyboardDismissMode = .interactive
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    fileprivate func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: selectedMoviesCollectionViewController.view.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    fileprivate func setupCreateButton() {
        createButton = UIButton()
        createButton.backgroundColor = UIColor.yellow
        createButton.addTarget(self, action: #selector(didSelectCreateButton), for: .touchUpInside)
        createButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
    }
    
}

