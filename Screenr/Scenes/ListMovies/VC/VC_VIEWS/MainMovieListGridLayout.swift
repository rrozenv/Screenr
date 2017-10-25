
import Foundation
import UIKit

class MainMovieListGridLayout: UICollectionViewFlowLayout {
    
    let itemSpacing: CGFloat = 15.0
    let itemsPerRow: CGFloat = 2
    
    override init() {
        super.init()
        self.minimumLineSpacing = itemSpacing
        self.minimumInteritemSpacing = itemSpacing
        self.scrollDirection = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    func itemWidth() -> CGFloat {
        return (collectionView!.frame.size.width/self.itemsPerRow) - self.itemSpacing
    }
    
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width:itemWidth(), height: itemWidth() * 1.3)
        }
        get {
            return CGSize(width:itemWidth(), height: itemWidth() * 1.3)
        }
    }
    
}


