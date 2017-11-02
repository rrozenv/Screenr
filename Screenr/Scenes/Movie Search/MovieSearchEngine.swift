
import Foundation
import PromiseKit

protocol MovieSearchLogic {
    func makeQuery(request: MoviesSearch.Request)
}

protocol MovieSearchDataStore {
    var movies: [Movie_R]! { get set }
}

final class MovieSearchEngine: MovieSearchLogic, MovieSearchDataStore {
    
    var presenter: MovieSearchPresentationLogic?
    var movies: [Movie_R]!
    fileprivate let webservice = WebService.shared
    
    func makeQuery(request: MoviesSearch.Request) {
        let resource = Movie_R.OMDBmoviesResource(for: request.query)
        fetchMovies(resource)
            .then { (movies) -> Void in
                self.saveMoviesToDataStore(movies)
                self.generateResponseForPresenter(with: movies)
            }
            .catch { (error) in
                if let httpError = error as? HTTPError {
                    print(httpError.description)
                } else {
                    print(error.localizedDescription)
                }
            }
    }
    
    fileprivate func generateResponseForPresenter(with movies: [Movie_R]) {
        let response = MoviesSearch.Response(movies: movies)
        self.presenter?.formatMovies(response: response)
    }
    
}

extension MovieSearchEngine {
    
    fileprivate func fetchMovies(_ resource: Resource<[Movie_R]>) -> Promise<[Movie_R]> {
        return webservice.load(resource)
    }
    
    fileprivate func saveMoviesToDataStore(_ movies: [Movie_R]) {
        self.movies = movies
    }
    
}
