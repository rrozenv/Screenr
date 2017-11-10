
import Foundation
import UIKit

final class ListContestsViewController: UIViewController {
    
    var tableView: UITableView!
    var displayedContests: [DisplayedContest] = []
    
    //var router: (NSObjectProtocol & ListShowtimesDataPassing)?
    var engine: ListContestsBusinessLogic?
    
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
        let engine = ListContestsEngine()
        let presenter = ListContestsPresenter()
        //let router = ListShowtimesRouter()
        viewController.engine = engine
        //viewController.router = router
        engine.presenter = presenter
        presenter.viewController = viewController
//        router.viewController = viewController
//        router.dataStore = engine
    }
    
    deinit {
        print("DEINIT OF DETAIL VC")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.red
        self.automaticallyAdjustsScrollViewInsets = false
        setupTableView()
        fetchCurrentContests()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Output
    func fetchCurrentContests() {
        let request = ListContests.FetchContests.Request()
        engine?.fetchContestsFromDataBase(request: request)
    }

    //MARK: Input
    func displayContests(viewModel: ListContests.FetchContests.ViewModel) {
        self.displayedContests = viewModel.displayedContests
        self.tableView.reloadData()
    }
    
    fileprivate func setupTableView() {
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(ContestTableViewCell.self, forCellReuseIdentifier: ContestTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(tableView)
    }

}

extension ListContestsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedContests.isEmpty ? 0 : displayedContests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContestTableViewCell.reuseIdentifier, for: indexPath) as? ContestTableViewCell else { fatalError("Unexpected Table View Cell") }
        let contest = self.displayedContests[indexPath.row]
        cell.configure(with: contest)
        return cell
    }
    
    
}
