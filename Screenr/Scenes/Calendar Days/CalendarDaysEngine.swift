
import Foundation

protocol CalendarDaysBusinessLogic {
    func getCalendarDays(request: CalendarDays.GetCalanderDays.Request)
}

final class CalendarDaysEngine: CalendarDaysBusinessLogic {
    
    var presenter: CalendarDaysPresenter?
    
    func getCalendarDays(request: CalendarDays.GetCalanderDays.Request) {
        let datesArray = Date.array(numberOfDays: 14, startDate: Date())
        let response =  CalendarDays.GetCalanderDays.Response(dates: datesArray)
        presenter?.presentCalendarDays(response: response)
    }
    
}

