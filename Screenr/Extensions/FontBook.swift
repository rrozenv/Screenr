
import Foundation
import UIKit

enum FontBook: String {
    case AvenirMedium = "Avenir-Medium"
    case AvenirHeavy = "Avenir-Heavy"
    case AvenirBlack = "Avenir-Black"
    
    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}
