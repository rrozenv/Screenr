
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
            self.saveMoviesToDataStore(cachedMovies)
            self.generateResponseForPresenter(with: cachedMovies)
        }
    }
    
    func loadMoviesFromNetwork(request: MainMovieList.Request) {
        let resource = moviesResource(for: request.location)
        moviesWorker.fetchCurrentlyPlayingMovies(resource).then { [weak self] movies -> Void in
            guard let strongSelf = self else { return }
            strongSelf.saveMoviesToDataStore(movies)
            strongSelf.generateResponseForPresenter(with: movies)
            }.catch { [weak self] (error) -> Void in
                guard let strongSelf = self else { return }
                strongSelf.generateResponseForPresenter(with: nil)
                print(error.localizedDescription)
            }
    }
    
    fileprivate func saveMoviesToDataStore(_ movies: [Movie]) {
        self.movies = movies
    }
    
    fileprivate func generateResponseForPresenter(with movies: [Movie]?) {
        if let movies = movies {
            let response = MainMovieList.Response(movies: movies)
            self.presenter?.presentMovieList(response: response)
        } else {
            let response = MainMovieList.Response(movies: nil)
            self.presenter?.presentMovieList(response: response)
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
