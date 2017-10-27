
import Foundation
import UIKit
import PromiseKit
import RealmSwift

protocol MainMovieListBusinessLogic {
    func loadMoviesFromNetwork(request: MainMovieList.Request)
    func loadCachedMovies(request: MainMovieList.Request)
    func saveMovieToDatabase(request: MainMovieList.SaveMovie.Request)
}

protocol MainMovieListDataStore {
    var movies: [Movie_R]? { get }
}

final class MainMovieListInteractor: MainMovieListBusinessLogic, MainMovieListDataStore {
    
    var presenter: MainMovieListPresentationLogic?
    var moviesWorker = MovieWorker()
    var movies: [Movie_R]?
    
    func loadCachedMovies(request: MainMovieList.Request) {
        let resource = moviesResource(for: request.location)
        if let cachedMovies = moviesWorker.loadCachedMovies(resource) {
            self.saveMoviesToDataStore(cachedMovies)
            self.generateResponseForPresenter(with: cachedMovies)
        }
    }
    
    func loadMoviesFromNetwork(request: MainMovieList.Request) {
        let resource = moviesResource(for: request.location)
        moviesWorker
            .fetchCurrentlyPlayingMovies(resource)
            .then { [weak self] movies -> Void in
                guard let strongSelf = self else { return }
                strongSelf.saveMoviesToDataStore(movies)
                strongSelf.generateResponseForPresenter(with: movies)
            }
            .catch { [weak self] (error) -> Void in
                guard let strongSelf = self else { return }
                strongSelf.generateResponseForPresenter(with: nil)
                print(error.localizedDescription)
            }
    }
    
    fileprivate func saveMoviesToDataStore(_ movies: [Movie_R]) {
        self.movies = movies
    }
    
    fileprivate func generateResponseForPresenter(with movies: [Movie_R]?) {
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
        let index = movies.index(where: { $0.movieID == request.movieId })
        if index != nil {
            let realm = try! Realm(configuration: RealmConfig.common.configuration)
            //let user = realm.objects(User.self).first
            try! realm.write {
                realm.add(movies[index!])
            }
            //RealmManager.addObject(movies[index!], primaryKey: movies[index!].uniqueID)
        }
    }
    
    private func moviesResource(for location: String?) -> Resource<[Movie_R]> {
        return Resource<[Movie_R]>(target: .currentMovies(location: location ?? "")) { json in
            guard let dictionaries = json as? [JSONDictionary] else { return nil }
            return dictionaries.flatMap(Movie_R.init)
        }
    }
    
}
