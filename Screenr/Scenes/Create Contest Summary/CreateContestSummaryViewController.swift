
import Foundation
import UIKit

final class CreateContestSummaryViewController: UIViewController, ChildViewControllerManager {
    
    var tableView: UITableView!
    var selectedMoviesCollectionViewController: DisplayMoviesCollectionViewController!
    var nextButton: UIButton!
    
    var engine: CreateContestSummaryEngine?
    var router:
    (CreateContestSummaryRoutingLogic &
    NSObjectProtocol)?
    
    var postalCodeButton: UIBarButtonItem!
    var locationDidChange = false
    
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
        setupChildSelectedMoviesViewController()
        setupTableView()
        setupNextButton()
        fetchSelectedMoviesFromDatabase()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        selectedMoviesCollectionViewController.view.frame = CGRect(x: 0, y: 10, width: self.view.frame.size.width, height: 100)
        tableView.frame = CGRect(x: 0, y: 110, width: self.view.frame.size.width, height: 550)
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return nextButton
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func didSelectNextButton(_ sender: UIButton) {
        router?.routeToMainMovieList()
    }
    
    func fetchSelectedMoviesFromDatabase() {
        engine?.fetchSelectedMoviesFromDatabase()
    }
    
    func displaySelectedMovies(viewModel: SelectMovies.ViewModel) {
        self.selectedMoviesCollectionViewController.displayedMovies = viewModel.displayedMovies
        self.selectedMoviesCollectionViewController.collectionView.reloadData()
    }
    
}

extension CreateContestSummaryViewController: UITableViewDataSource, UITableViewDelegate {
    
    enum Cell: Int {
        case date = 0
        case price = 1
        case votes = 2
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as? TextFieldCell else { fatalError("Unexpected Table View Cell") }
            cell.configure(with: .price, inputValue: nil)
            return cell
        case .price:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as? TextFieldCell else { fatalError("Unexpected Table View Cell") }
            cell.configure(with: .price, inputValue: nil)
            return cell
        case .votes:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as? TextFieldCell else { fatalError("Unexpected Table View Cell") }
            cell.configure(with: .votes, inputValue: nil)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
}

extension CreateContestSummaryViewController {
    
    fileprivate func setupChildSelectedMoviesViewController() {
        selectedMoviesCollectionViewController = DisplayMoviesCollectionViewController(gridLayout: SelectedMoviesGridLayout())
        self.addChildViewController(selectedMoviesCollectionViewController, frame: nil, animated: false)
    }
    
    fileprivate func setupTableView() {
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.reuseIdentifier)
        tableView.register(DisplayedTheatreSearchCell.self, forCellReuseIdentifier: DisplayedTheatreSearchCell.reuseIdentifier)
        tableView.keyboardDismissMode = .interactive
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    fileprivate func setupNextButton() {
        nextButton = UIButton()
        nextButton.backgroundColor = UIColor.yellow
        nextButton.addTarget(self, action: #selector(didSelectNextButton), for: .touchUpInside)
        nextButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
    }
    
}

