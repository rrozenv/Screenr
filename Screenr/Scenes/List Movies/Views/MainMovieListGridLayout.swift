
import Foundation
import UIKit

class MainMovieListGridLayout: UICollectionViewFlowLayout {
    
    let itemSpacing: CGFloat = 20
    let itemsPerRow: CGFloat = 2
    let inset: CGFloat = 20
    
    override init() {
        super.init()
        self.minimumLineSpacing = inset
        self.minimumInteritemSpacing = itemSpacing / 2
        self.scrollDirection = .vertical
        self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    func itemWidth() -> CGFloat {
        return (collectionView!.frame.size.width/self.itemsPerRow) - (self.itemSpacing / 2) - self.inset
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


