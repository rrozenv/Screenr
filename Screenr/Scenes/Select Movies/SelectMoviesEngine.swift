
import Foundation

protocol SelectMoviesLogic {
    func saveSelectedMovie(request: SelectMovies.Request)
    func saveSelectedMoviesToDatabase()
    func deleteAllObjectsInTemporaryRealm()
    func removeSelectedMovie(request: SelectMovies.RemoveSelectedMovie.Request)
}

protocol SelectMoviesDataStore {
    var selectedMovies: [ContestMovie_R] { get set }
}

final class SelectMoviesEngine: SelectMoviesLogic, SelectMoviesDataStore {
    
    //MARK: - Properties
    
    var selectedMovies = [ContestMovie_R]()
    var presenter: SelectMoviesPresentationLogic?
    lazy var temporaryRealm: RealmStorageContext = {
        return RealmStorageContext(configuration: RealmConfig.temporary)
    }()
    
    //MARK: - Logic Methods
    
    func saveSelectedMovie(request: SelectMovies.Request) {
        guard !isMovieSelected(movieID: request.movie.movieID) else { return }
        self.selectedMovies.append(request.movie)
        self.passMoviesToPresenter()
    }
    
    func removeSelectedMovie(request: SelectMovies.RemoveSelectedMovie.Request) {
        if let index = selectedMovies.index(where: { $0.movieID == request.movieID }) {
            self.selectedMovies.remove(at: index)
        }
        self.passMoviesToPresenter()
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
    
    func deleteAllObjectsInTemporaryRealm() {
        self.temporaryRealm
            .deleteAll()
            .catch { (error) in
                if let realmError = error as? RealmError {
                    print(realmError.description)
                } else {
                    print(error.localizedDescription)
                }
        }
    }
    
}

//MARK: - Private Methods

extension SelectMoviesEngine {
    
    fileprivate func passMoviesToPresenter() {
        let response = SelectMovies.Response(movies: self.selectedMovies)
        self.presenter?.formatMovies(response: response)
    }
    
    fileprivate func isMovieSelected(movieID: String) -> Bool {
        return selectedMovies.contains { $0.movieID == movieID }
    }
    
}
