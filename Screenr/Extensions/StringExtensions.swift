
import Foundation

extension String {
    
    var convertToDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let calendar = Calendar.current
        guard let date = formatter.date(from: self) else { return nil }
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let finalDate = calendar.date(from:components)
        return finalDate
    }
    
}
