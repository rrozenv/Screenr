
import Foundation
import UIKit

typealias DisplayedContest = ListContests.FetchContests.ViewModel.DisplayedContest

protocol ListContestsPresentationLogic {
    func formatContests(response: ListContests.FetchContests.Response)
}

class ListContestsPresenter: ListContestsPresentationLogic {
    
    weak var viewController: ListContestsViewController?
    
    func formatContests(response: ListContests.FetchContests.Response) {
        let displayedContests = response.contests.map { (contest) -> DisplayedContest in
            let theatreName = contest.theatre?.name ?? "No Theatre Name"
            return DisplayedContest(theatreName: theatreName, ticketPrice: contest.ticketPrice, votesRequired: contest.votesRequired, calendarDate: contest.calendarDate.yearMonthDayString, movies: Array(contest.movies))
        }
        let viewModel = ListContests.FetchContests.ViewModel(displayedContests: displayedContests)
        viewController?.displayContests(viewModel: viewModel)
    }
    
}
