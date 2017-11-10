
import Foundation
import UIKit

extension Int {
    
    func isOdd() -> Bool {
        guard self % 2 == 1 else { return false }
        return true
    }
    
}

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

extension UIView {
    
    func constrainEdges(to view: UIView) {
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    func dropShadow(scale: Bool = true) {
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 5
    }
    
}
