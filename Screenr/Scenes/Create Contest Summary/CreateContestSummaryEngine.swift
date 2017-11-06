
import Foundation

protocol CreateContestSummaryLogic {
    func fetchSelectedMoviesFromDatabase()
}

protocol CreateContestSummaryDataStore {
    var selectedMovies: [Movie_R] { get set }
}

final class CreateContestSummaryEngine: CreateContestSummaryLogic, CreateContestSummaryDataStore {
    
    var selectedMovies = [Movie_R]()
    var presenter: CreateContestSummaryPresenter?
    lazy var temporaryRealm: RealmStorageContext = {
        return RealmStorageContext(configuration: RealmConfig.temporary)
    }()
    
    func fetchSelectedMoviesFromDatabase() {
        self.temporaryRealm
            .fetch(Movie_R.self)
            .then { (movies) -> Void in
                self.selectedMovies = movies
                let response = CreateContestSummary.SelectedMovies.Response(movies: movies)
                self.presenter?.formatMovies(response: response)
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
