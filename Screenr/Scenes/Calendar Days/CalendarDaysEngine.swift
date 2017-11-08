
import Foundation

protocol CalendarDaysBusinessLogic {
    func getCalendarDays(request: CalendarDays.GetCalanderDays.Request)
}

protocol CalendarDayDataStore {
    var dates: [Date]! { get set }
}

final class CalendarDaysEngine: CalendarDaysBusinessLogic, CalendarDayDataStore {
    
    var presenter: CalendarDaysPresenter?
    var dates: [Date]!
    
    func getCalendarDays(request: CalendarDays.GetCalanderDays.Request) {
        dates = Date.array(numberOfDays: request.numberOfDays, startDate: Date())
        let response =  CalendarDays.GetCalanderDays.Response(dates: dates)
        presenter?.presentCalendarDays(response: response)
    }
    
}

