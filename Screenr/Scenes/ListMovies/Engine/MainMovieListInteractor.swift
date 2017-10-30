
import Foundation
import UIKit
import PromiseKit
import RealmSwift

protocol MainMovieListBusinessLogic {
    func loadMoviesFromNetworkForCurrentLocation(request: MainMovieList.Request)
    func loadMoviesFromNetworkForUpdatedLocation() 
    func loadCachedMovies(request: MainMovieList.Request)
    func saveMovieToDatabase(request: MainMovieList.SaveMovie.Request)
}

protocol MainMovieListDataStore {
    var movies: [Movie_R]? { get }
    var currentlySelectedLocation: Location_R? { get set }
}

final class MainMovieListInteractor: MainMovieListBusinessLogic, MainMovieListDataStore {
    
    var presenter: MainMovieListPresentationLogic?
    var moviesWorker = MovieWorker()
    var movies: [Movie_R]?
    var currentlySelectedLocation: Location_R?
    
    func loadCachedMovies(request: MainMovieList.Request) {
        let resource = moviesResource(for: request.location)
        if let cachedMovies = moviesWorker.loadCachedMovies(resource) {
            self.saveMoviesToDataStore(cachedMovies)
            self.generateResponseForPresenter(with: cachedMovies)
        }
    }
    
    //Called only once per session
    func loadMoviesFromNetworkForCurrentLocation(request: MainMovieList.Request) {
        let resource = moviesResource(for: request.location)
        saveCurrentLocationToDatabase(request.location!)
        fetchMovies(resource)
    }
    
    //Called if user updates location through LocationSearchViewController
    func loadMoviesFromNetworkForUpdatedLocation() {
        guard let zipCode = currentlySelectedLocation?.code else { return }
        presenter?.displayUpdatedLocation(location: zipCode)
        let resource = moviesResource(for: zipCode)
        fetchMovies(resource)
    }
    
    func saveCurrentLocationToDatabase(_ location: String) {
        UserDefaults.standard.set(location, forKey: "usersLocation")
        let realm = try! Realm(configuration: RealmConfig.secret.configuration)
        let locationExists = realm.objects(Location_R.self).filter("code == %@", "\(location)")
        if locationExists.count < 1 {
            let location = Location_R(zipCode: location, name: nil)
            location.isCurrentlySelected = true
            let realm = try! Realm(configuration: RealmConfig.secret.configuration)
            try! realm.write {
                //let loc = realm.create(Location_R.self, value:["code": location.code, "name": nil])
                realm.add(location, update: true)
            }
        }
    }
    
    fileprivate func fetchMovies(_ resource: Resource<[Movie_R]>) {
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
