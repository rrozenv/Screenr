
import Foundation

typealias DisplayedTheatre = ListShowtimes.GetShowtimes.ViewModel.DisplayedTheatre

protocol ListShowtimesPresentationLogic {
    func presentMovieShowtimes(response: ListShowtimes.GetShowtimes.Response)
}

class ListShowtimesPresenter: ListShowtimesPresentationLogic {
    
    weak var viewController: ListShowTimesViewController?
    
    func presentMovieShowtimes(response: ListShowtimes.GetShowtimes.Response) {
        if let uniqueTheaters = response.movie.getUniqueTheatres() {
            let displayedTheatres = uniqueTheaters.map { (theatre) -> DisplayedTheatre in
                return getShowtimesFor(movie: response.movie, at: theatre)
            }
            let viewModel = ListShowtimes.GetShowtimes.ViewModel(displayedTheaters: displayedTheatres)
            viewController?.displayMovieShowtimes(viewModel: viewModel)
        } else {
            let viewModel = ListShowtimes.GetShowtimes.ViewModel(displayedTheaters: [DisplayedTheatre]())
            viewController?.displayMovieShowtimes(viewModel: viewModel)
        }
    }

}

extension ListShowtimesPresenter {
    
    fileprivate func getShowtimesFor(movie: Movie, at theatre: Theatre) -> DisplayedTheatre {
        guard let showtimes = movie.getShowtimesFor(theatreID: theatre.id) else {
            return DisplayedTheatre(theatreID: theatre.id, name: theatre.name, movie: movie, showtimes: nil)
        }
        let formattedShowtimes = formatShowtimes(showtimes)
        return DisplayedTheatre(theatreID: theatre.id, name: theatre.name, movie: movie, showtimes: formattedShowtimes)
    }
    
    fileprivate func formatShowtimes(_ showtimes: [Showtime]) -> [Showtime] {
        var formattedShowtimes = [Showtime]()
        showtimes.forEach {
            if let formattedShowtime = $0.formattedShowTime {
                formattedShowtimes.append(formattedShowtime)
            }
        }
        return formattedShowtimes
    }
    
}



