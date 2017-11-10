
import Foundation

extension Date {
    
    struct Formatter {
        static var shared: DateFormatter {
            let shared = DateFormatter()
            shared.locale = Locale(identifier: "en_US")
            return shared
        }
    }
    
    var yearMonthDayString: String {
        let formatter = Formatter.shared
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    var timeOnlyString: String {
        let formatter = Formatter.shared
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: self)
    }
    
    var dayWeekdayMonth: (day: Int, month: Int, weekday: String) {
        let calendar = Calendar.current
        let weekDay = calendar.component(.weekday, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        return (day: day, month: month, weekday: weekDay.weekDayShort)
    }
    
}

enum WeekDay {
    case monday(String)
    case tuesday(String)
    case wednesday(String)
    case thursday(String)
    case friday(String)
    case saturday(String)
    case sunday(String)
}

extension Int {
    
    var weekDayShort: String {
        switch self {
        case 1:
            return "MON"
        case 2:
            return "TUE"
        case 3:
            return "WED"
        case 4:
            return "THU"
        case 5:
            return "FRI"
        case 6:
            return "SAT"
        case 7:
            return "SUN"
        default:
            return "???"
        }
    }
    
}

extension Date {
    
    static func array(numberOfDays: Int, startDate: Date) -> [Date] {
        let calendar = Calendar.current
        var offset = DateComponents()
        var dates = [startDate]
        
        for i in 1..<numberOfDays {
            offset.day = i
            if let nextDay = calendar.date(byAdding: offset, to: startDate) {
                dates.append(nextDay)
            }
        }
        
        return dates
    }
    
}
