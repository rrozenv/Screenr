
import Foundation

protocol SelectMoviesLogic {
    func saveSelectedMovie(request: SelectMovies.Request)
}

protocol SelectMoviesDataStore {
    var selectedMovies: [Movie_R] { get set }
}

final class SelectMoviesEngine: SelectMoviesLogic, SelectMoviesDataStore {
    
    var selectedMovies = [Movie_R]()
    var presenter: SelectMoviesPresentationLogic?
    
    func saveSelectedMovie(request: SelectMovies.Request) {
        self.selectedMovies.append(request.movie)
        let response = SelectMovies.Response(movies: selectedMovies)
        self.presenter?.formatMovies(response: response)
    }
    
}
