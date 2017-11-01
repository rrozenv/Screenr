
import Foundation
import PromiseKit

protocol MovieSearchLogic {
    func makeQuery(request: MoviesSearch.Request)
}

protocol MovieSearchDataStore {
    var movies: [Movie_R]! { get set }
}

final class MovieSearchEngine: MovieSearchLogic, MovieSearchDataStore {
    
    var presenter: LocationSearchPresentationLogic?
    var movies: [Movie_R]!
    private let webservice = WebService.shared
    
    func makeQuery(request: MoviesSearch.Request) {
        let resource = Movie_R.OMDBmoviesResource(for: request.query)
        fetchMovies(resource)
            .then { (movies) in
                self.saveMoviesToDataStore(movies)
            }
            .catch { (error) in
                if let httpError = error as? HTTPError {
                    print(httpError.description)
                } else {
                    print(error.localizedDescription)
                }
            }
    }
    
    func fetchMovies(_ resource: Resource<[Movie_R]>) -> Promise<[Movie_R]> {
        return webservice.load(resource)
    }
    
    fileprivate func saveMoviesToDataStore(_ movies: [Movie_R]) {
        self.movies = movies
    }
    
}
