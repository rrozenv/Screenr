
import Foundation

protocol SelectMoviesLogic {
    func saveSelectedMovie(request: SelectMovies.Request)
    func saveSelectedMoviesToDatabase()
}

protocol SelectMoviesDataStore {
    var selectedMovies: [Movie_R] { get set }
}

final class SelectMoviesEngine: SelectMoviesLogic, SelectMoviesDataStore {
    
    var selectedMovies = [Movie_R]()
    var presenter: SelectMoviesPresentationLogic?
    lazy var temporaryRealm: RealmStorageContext = {
        return RealmStorageContext(configuration: RealmConfig.temporary)
    }()
    
    func saveSelectedMovie(request: SelectMovies.Request) {
        self.selectedMovies.append(request.movie)
        let response = SelectMovies.Response(movies: selectedMovies)
        self.presenter?.formatMovies(response: response)
    }
    
    func saveSelectedMoviesToDatabase() {
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
