
import Foundation
import UIKit

final class TheatreTableViewCell: UITableViewCell {
    
    // MARK: - Type Properties
    
    static let reuseIdentifier = "TheatreCell"
    
    // MARK: - Properties
    fileprivate var collectionViewHeightAnchor: NSLayoutConstraint!
    fileprivate var collectionView: UICollectionView!
    fileprivate var collectionFlowLayout: UICollectionViewFlowLayout!
    fileprivate var showtimes: [Showtime_R] = []
    
    fileprivate var theatreNameLabel: UILabel!
    fileprivate var showtimesLabel: UILabel!
    fileprivate var containerView: UIView!
    
    // MARK: - Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        setupContainerView()
        setupCollectionViewLayout()
        setupCollectionViewProperties()
        setupCollectionViewConstraints()
        //setupLabels()
    }
    
    func configure(with displayedTheatre: ListShowtimes.GetShowtimes.ViewModel.DisplayedTheatre) {
        //theatreNameLabel.text = displayedTheatre.name
        showtimes = displayedTheatre.showtimes ?? []
        collectionView.reloadData()
        resizeCollectionView()
        //showtimesLabel.text = showtimeString
    }
    
    fileprivate func setupCollectionViewLayout() {
        collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.minimumLineSpacing = 1
        collectionFlowLayout.minimumInteritemSpacing = 1
        collectionFlowLayout.scrollDirection = .vertical
    }
    
    fileprivate func setupCollectionViewProperties() {
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: collectionFlowLayout)
        collectionView.backgroundColor = UIColor.orange
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MainMovieListCell.self, forCellWithReuseIdentifier: MainMovieListCell.reuseIdentifier)
    }
    
    func setupCollectionViewConstraints() {
        containerView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        collectionViewHeightAnchor = collectionView.heightAnchor.constraint(equalToConstant: 1)
        collectionViewHeightAnchor.isActive = true
    }
    
    fileprivate func setupContainerView() {
        containerView = UIView()
        contentView.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    fileprivate func setupLabels() {
        theatreNameLabel = UILabel()
        theatreNameLabel.numberOfLines = 1
        containerView.addSubview(theatreNameLabel)
        
        theatreNameLabel.translatesAutoresizingMaskIntoConstraints = false
        theatreNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        theatreNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        theatreNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        theatreNameLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -10).isActive = true
    }
    
}

extension TheatreTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showtimes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainMovieListCell.reuseIdentifier, for: indexPath) as! MainMovieListCell
        cell.label.text = showtimes[indexPath.item].time
        return cell
    }
    
}

extension TheatreTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if showtimes.count % 2 == 0 {
            return CGSize(width: (containerView.frame.size.width / 2) - 1, height: containerView.frame.size.width * 0.152)
        } else {
            if indexPath.row != showtimes.count - 1 {
                return CGSize(width: (containerView.frame.size.width / 2) - 1, height:  containerView.frame.size.width * 0.152)
            } else {
                return CGSize(width: containerView.frame.size.width, height:  containerView.frame.size.width * 0.152)
            }
        }

    }
    
    func resizeCollectionView() {
        let multiplier = ((UIScreen.main.bounds.size.width - 20) * 0.152)
        let height = CGFloat(CGFloat(showtimes.count) * multiplier ) / 2
        self.collectionViewHeightAnchor.constant = height
        //self.contentView.setNeedsLayout()
        self.contentView.superview?.setNeedsLayout()
    }
    
}
