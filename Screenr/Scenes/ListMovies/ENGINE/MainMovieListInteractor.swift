
import Foundation
import UIKit
import PromiseKit

protocol MainMovieListBusinessLogic {
    func loadMoviesFromNetwork(request: MainMovieList.Request)
    func loadCachedMovies(request: MainMovieList.Request)
    func saveMovieToDatabase(request: MainMovieList.SaveMovie.Request)
}

protocol MainMovieListDataStore {
    var movies: [Movie]? { get }
}

final class MainMovieListInteractor: MainMovieListBusinessLogic, MainMovieListDataStore {
    
    var presenter: MainMovieListPresentationLogic?
    var moviesWorker = MovieWorker()
    var movies: [Movie]?
    
    func loadCachedMovies(request: MainMovieList.Request) {
        let resource = moviesResource(for: request.location)
        if let cachedMovies = moviesWorker.loadCachedMovies(resource) {
            self.movies = cachedMovies
            let response = MainMovieList.Response(movies: cachedMovies)
            self.presenter?.presentCachedMovieList(response: response)
        }
    }
    
    func loadMoviesFromNetwork(request: MainMovieList.Request) {
        let resource = moviesResource(for: request.location)
        moviesWorker.fetchCurrentlyPlayingMovies(resource).then { [weak self] movies -> Void in
            guard let strongSelf = self else { return }
            strongSelf.movies = movies
            let response = MainMovieList.Response(movies: movies)
            strongSelf.presenter?.presentMovieList(response: response)
            }.catch { [weak self] (error) -> Void in
                guard let strongSelf = self else { return }
                let response = MainMovieList.Response(movies: nil)
                strongSelf.presenter?.presentMovieList(response: response)
                print(error.localizedDescription)
            }
    }
    
    func saveMovieToDatabase(request: MainMovieList.SaveMovie.Request) {
        guard let movies = movies else { return }
        let index = movies.index(where: { $0.id == request.movieId })
        if index != nil {
            RealmManager.addObject(movies[index!], primaryKey: movies[index!].id)
        }
    }
    
    private func moviesResource(for location: String) -> Resource<[Movie]> {
        return Resource<[Movie]>(target: .currentMovies(location: location)) { json in
            guard let dictionaries = json as? [JSONDictionary] else { return nil }
            return dictionaries.flatMap(Movie.init)
        }
    }
    
}
