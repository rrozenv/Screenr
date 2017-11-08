
import Foundation

typealias DisplayedDate = CalendarDays.GetCalanderDays.ViewModel.DisplayedDate

protocol CalendarDaysPresentationLogic {
    func presentCalendarDays(response: CalendarDays.GetCalanderDays.Response)
}

class CalendarDaysPresenter: CalendarDaysPresentationLogic {
    
    weak var viewController: CalendarDayCollectionViewController?
    
    func presentCalendarDays(response: CalendarDays.GetCalanderDays.Response) {
        let displayedDates = response.dates.map { (date) -> DisplayedDate in
            let components = date.dayWeekdayMonth
            return DisplayedDate(date: date, fullDateString: date.yearMonthDayString, calendarDay: String(components.day), month: String(components.month), weekDay: components.weekday)
        }
        let viewModel = CalendarDays.GetCalanderDays.ViewModel(displayedDates: displayedDates)
        viewController?.displayCalendarDays(viewModel: viewModel)
    }
    
}
