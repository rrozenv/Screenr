
import Foundation

protocol CreateContestSummaryLogic {
    func fetchSelectedMoviesFromDatabase()
    func createContestInDatabase()
    func deleteAllObjectsInTemporaryRealm()
    func updateTicketPrice(to price: String)
    func updateVotesRequired(to numberOfVotes: String)
}

protocol CreateContestSummaryDataStore {
    var selectedMovies: [ContestMovie_R] { get set }
    var theatre: Theatre_R? { get set }
    var ticketPrice: String { get set }
    var votesRequired: String { get set }
}

final class CreateContestSummaryEngine: CreateContestSummaryLogic, CreateContestSummaryDataStore {
    
    lazy var temporaryRealm: RealmStorageContext = {
        return RealmStorageContext(configuration: RealmConfig.temporary)
    }()
    
    lazy var commonRealm: RealmStorageContext = {
        return RealmStorageContext(configuration: RealmConfig.common)
    }()
    
    var selectedMovies = [ContestMovie_R]()
    var theatre: Theatre_R?
    var presenter: CreateContestSummaryPresentationLogic?
    var date: Date = Date()
    var ticketPrice: String = TextFieldCell.Style.price.defaultValue
    var votesRequired: String = TextFieldCell.Style.votes.defaultValue
    
    func fetchSelectedMoviesFromDatabase() {
        self.temporaryRealm
            .fetch(ContestMovie_R.self)
            .then { (movies) -> Void in
                self.selectedMovies = movies
                let response = CreateContestSummary.SelectedMovies.Response(movies: movies)
                self.presenter?.formatMovies(response: response)
            }
            .catch { (error) in
                if let realmError = error as? RealmError {
                    print(realmError.description)
                } else {
                    print(error.localizedDescription)
                }
            }
    }
    
    func fetchSelectedTheatreFromDatabase() {
        self.temporaryRealm
            .fetch(Theatre_R.self)
            .then { (theatres) -> Void in
                self.theatre = theatres.first
                let response = CreateContestSummary.SelectedTheatre.Response(theatre: theatres.first!)
                self.presenter?.formatTheatre(response: response)
            }
            .catch { (error) in
                if let realmError = error as? RealmError {
                    print(realmError.description)
                } else {
                    print(error.localizedDescription)
                }
        }
    }
    
    func createContestInDatabase() {
        let value = Contest_R.createValueDictionary(theatre: theatre!, calendarDate: date, movies: selectedMovies, ticketPrice: ticketPrice, votesRequired: votesRequired)
        self.commonRealm
            .create(Contest_R.self, value: value)
            .then { (_) in
                self.presenter?.displayDidCreateContestConfirmation()
            }
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
    
    func updateDate(to date: Date) {
        self.date = date
        self.presenter?.displayUpdatedDate()
    }
    
    func updateTicketPrice(to price: String) {
        self.ticketPrice = price
        self.presenter?.displayUpdatedPrice()
    }
    
    func updateVotesRequired(to numberOfVotes: String) {
        self.votesRequired = numberOfVotes
        self.presenter?.displayUpdatedVotesRequired()
    }
    
}
