
import Foundation
import UIKit

final class TheatreTableViewCell: UITableViewCell {
    
    // MARK: - Type Properties
    static let reuseIdentifier = "TheatreCell"
    
    // MARK: - Properties
    fileprivate var containerView = UIView()
    fileprivate var headerView = TheatreCellHeaderView()
    
    fileprivate var collectionViewHeightAnchor: NSLayoutConstraint!
    fileprivate var collectionView: UICollectionView!
    fileprivate var collectionFlowLayout: UICollectionViewFlowLayout!
    fileprivate var showtimes: [Showtime_R] = []
    
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
        setupContainerViewConstraints()
        
        setupCollectionViewLayout()
        setupCollectionViewProperties()
        setupCollectionViewConstraints()
        
        setupHeaderViewConstraints()
    }
    
    func configure(with displayedTheatre: ListShowtimes.GetShowtimes.ViewModel.DisplayedTheatre) {
        headerView.titleLabel.text = displayedTheatre.name
        showtimes = displayedTheatre.showtimes ?? []
        collectionView.reloadData()
        resizeCollectionView()
    }
    
}

// MARK: - Property Setup

extension TheatreTableViewCell {
    
    fileprivate func setupCollectionViewLayout() {
        collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.minimumLineSpacing = 1
        collectionFlowLayout.minimumInteritemSpacing = 1
        collectionFlowLayout.scrollDirection = .vertical
    }
    
    fileprivate func setupCollectionViewProperties() {
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: collectionFlowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ShowtimeCell.self, forCellWithReuseIdentifier: ShowtimeCell.reuseIdentifier)
    }
    
}

// MARK: - Collection View Datasource

extension TheatreTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showtimes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowtimeCell.reuseIdentifier, for: indexPath) as! ShowtimeCell
        cell.label.text = showtimes[indexPath.item].time
        return cell
    }
    
}

// MARK: - Collection View Delegate

extension TheatreTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if !showtimes.count.isOdd() {
            return CGSize(width: (containerView.frame.size.width / 2) - 1, height: containerView.frame.size.width * 0.152)
        } else {
            if isLastShowtime(at: indexPath.row) {
               return CGSize(width: containerView.frame.size.width, height:  containerView.frame.size.width * 0.152)
            } else {
                return CGSize(width: (containerView.frame.size.width / 2) - 1, height:  containerView.frame.size.width * 0.152)
            }
        }
    }
    
    fileprivate func isLastShowtime(at indexPath: Int) -> Bool {
        guard indexPath == showtimes.count - 1 else { return false }
        return true
    }
    
    func resizeCollectionView() {
        let heightPerRow = ((UIScreen.main.bounds.size.width - 20) * 0.152)
        var heightForCV: CGFloat
        if !showtimes.count.isOdd() {
            heightForCV = CGFloat(CGFloat(showtimes.count) * heightPerRow) / 2
        } else {
            heightForCV = (CGFloat(CGFloat(showtimes.count - 1) * heightPerRow) / 2) + heightPerRow
        }
        self.collectionViewHeightAnchor.constant = heightForCV
        self.contentView.superview?.setNeedsLayout()
    }
    
}

// MARK: - Setup Constraints

extension TheatreTableViewCell {
    
    fileprivate func setupContainerViewConstraints() {
        containerView.layer.cornerRadius = 2.0
        containerView.layer.masksToBounds = true
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    func setupCollectionViewConstraints() {
        containerView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        collectionViewHeightAnchor = collectionView.heightAnchor.constraint(equalToConstant: 1)
        collectionViewHeightAnchor.isActive = true
    }
    
    func setupHeaderViewConstraints() {
        containerView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.size.width - 20) * 0.152).isActive = true
        headerView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -1).isActive = true
    }
    
}

// MARK: - Private Subviews

extension TheatreTableViewCell {
    
    final class TheatreCellHeaderView: UIView {
        var containerView: UIView!
        var titleLabel: UILabel!
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        init() {
            super.init(frame: .zero)
            self.backgroundColor = UIColor.clear
            setupContainerView()
            setupTitleLabel()
        }
        
        fileprivate func setupContainerView() {
            containerView = UIView()
            containerView.backgroundColor = UIColor.darkGray
            
            self.addSubview(containerView)
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.constrainEdges(to: self)
        }
        
        fileprivate func setupTitleLabel() {
            titleLabel = UILabel()
            titleLabel.font = FontBook.AvenirHeavy.of(size: 13)
            titleLabel.textColor = UIColor.white
            
            containerView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        }
    }
    
    final class ShowtimeCell: UICollectionViewCell {
        
        static let reuseIdentifier = "ShowtimeCell"
        var label: UILabel!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.backgroundColor = UIColor.red
            setupLabelProperties()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            setupLabelConstraints()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupLabelProperties() {
            label = UILabel()
            label.numberOfLines = 0
            label.font = FontBook.AvenirHeavy.of(size: 13)
            label.textColor = UIColor.white
        }
        
        private func setupLabelConstraints() {
            contentView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        }
        
    }
    
}
