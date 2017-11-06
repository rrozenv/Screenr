
import Foundation

protocol CreateContestSummaryLogic {
    func fetchSelectedMoviesFromDatabase()
}

protocol CreateContestSummaryDataStore {
    var selectedMovies: [Movie_R] { get set }
}

final class CreateContestSummaryEngine: CreateContestSummaryLogic, CreateContestSummaryDataStore {
    
    var selectedMovies = [Movie_R]()
    var presenter: SelectMoviesPresentationLogic?
    lazy var temporaryRealm: RealmStorageContext = {
        return RealmStorageContext(configuration: RealmConfig.temporary)
    }()
    
    func fetchSelectedMoviesFromDatabase() {
        self.temporaryRealm
            .save(objects: selectedMovies)
            .catch { (error) in
                if let realmError = error as? RealmError {
                    print(realmError.description)
                } else {
                    print(error.localizedDescription)
                }
        }
    }
    
}
