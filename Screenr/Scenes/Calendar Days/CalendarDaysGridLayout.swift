
import Foundation
import UIKit

class CalendarDaysGridLayout: UICollectionViewFlowLayout {
    
    let itemSpacing: CGFloat = 15.0
    let itemsPerRow: CGFloat = 3.5
    
    override init() {
        super.init()
        self.minimumLineSpacing = itemSpacing
        self.minimumInteritemSpacing = itemSpacing
        self.scrollDirection = .horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func itemWidth() -> CGFloat {
        return (collectionView!.frame.size.width/self.itemsPerRow) - self.itemSpacing
    }
    
    override var itemSize: CGSize {
        get {
            return CGSize(width: itemWidth(), height: itemWidth())
        }
        set {
            self.itemSize = CGSize(width: itemWidth(), height: itemWidth())
        }
    }
    
}
