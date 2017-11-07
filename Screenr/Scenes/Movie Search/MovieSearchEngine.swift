
import Foundation
import PromiseKit
import RealmSwift

protocol MovieSearchLogic {
    func makeQuery(request: MoviesSearch.ContestMovies.Request)
    func getMovieAtIndex(_ index: Int) -> ContestMovie_R?
}

protocol MovieSearchDataStore {
    var movies: [Movie_R] { get set }
    var contestMovies: [ContestMovie_R] { get set }
}

final class MovieSearchEngine: MovieSearchLogic, MovieSearchDataStore {
    
    var presenter: MovieSearchPresentationLogic?
    var movies: [Movie_R] = [Movie_R]()
    var contestMovies: [ContestMovie_R] = [ContestMovie_R]()
    fileprivate let webservice = WebService.shared
    
    func makeQuery(request: MoviesSearch.ContestMovies.Request) {
        let resource = ContestMovie_R.OMDBmoviesResource(for: request.query)
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
    
    func getMovieAtIndex(_ index: Int) -> ContestMovie_R? {
        guard index < contestMovies.count else { return nil }
        return contestMovies[index]
    }
    
    fileprivate func generateResponseForPresenter(with movies: [ContestMovie_R]) {
        let response = MoviesSearch.ContestMovies.Response(movies: movies)
        self.presenter?.formatMovies(response: response)
    }
    
}

extension MovieSearchEngine {
    
    fileprivate func fetchMovies(_ resource: Resource<[ContestMovie_R]>) -> Promise<[ContestMovie_R]> {
        return webservice.load(resource)
    }
    
    fileprivate func saveMoviesToDataStore(_ movies: [ContestMovie_R]) {
        self.contestMovies = movies
    }
    
}
