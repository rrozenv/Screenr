
import Foundation

protocol ListContestsDataStore {
    var contests: [Contest_R]? { get set }
}

protocol ListContestsBusinessLogic {
    func fetchContestsFromDataBase(request: ListContests.FetchContests.Request)
}

final class ListContestsEngine: ListContestsDataStore, ListContestsBusinessLogic {
    
    var contests: [Contest_R]?
    var presenter: ListContestsPresentationLogic?
    
    lazy var commonRealm: RealmStorageContext = {
        return RealmStorageContext(configuration: RealmConfig.common)
    }()
    
    func fetchContestsFromDataBase(request: ListContests.FetchContests.Request) {
        self.commonRealm
            .fetch(Contest_R.self)
            .then { (contests) -> Void in
                self.contests = contests
                let response = ListContests.FetchContests.Response(contests: contests)
                self.presenter?.formatContests(response: response)
            }
            .catch { (error) in
                if let realmError = error as? RealmError {
                    print(realmError.description)
                } else {
                    print(error.localizedDescription)
                }
        }
    }
    
}
