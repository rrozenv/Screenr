
import Foundation
import UIKit

final class ContestTableViewCell: UITableViewCell {
    
    // MARK: - Type Properties
    static let reuseIdentifier = "ContestTableViewCell"
    
    var collectionView: UICollectionView!
    var displayedMovies: [ContestMovie_R] = []
    
    // MARK: - Properties
    fileprivate var containerView: UIView!
    fileprivate var titleLabel: UILabel!
    fileprivate var dateLabel: UILabel!
    fileprivate var labelsStackView: UIStackView!

    // MARK: - Initialization
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func commonInit() {
        self.contentView.backgroundColor = UIColor.white
        self.separatorInset = .zero
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = .zero
        setupContainerViewProperties()
        setupCollectionViewProperties()
        setupTitleLabelProperties()
        setupDateLabelProperties()
        setupLabelsStackViewProperties()
        
        setupContainerViewConstraints()
        setupCollectionViewConstraints()
        setupStackViewConstraints()
    }
    
    fileprivate func setupCollectionViewProperties() {
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: SelectedMoviesGridLayout())
        collectionView.backgroundColor = UIColor.orange
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MainMovieListCell.self, forCellWithReuseIdentifier: MainMovieListCell.reuseIdentifier)
    }
    
    func configure(with contest: DisplayedContest) {
        self.selectionStyle = .none
        titleLabel.text = contest.theatreName
        dateLabel.text = contest.calendarDate
        displayedMovies = contest.movies
        collectionView.reloadData()
    }
    
    override func prepareForReuse() { }
    
}

extension ContestTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainMovieListCell.reuseIdentifier, for: indexPath) as! MainMovieListCell
        cell.label.text = displayedMovies[indexPath.item].title
        return cell
    }
    
}

extension ContestTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
}

//MARK: View Property Setup

extension ContestTableViewCell {
    
    fileprivate func setupContainerViewProperties() {
        containerView = UIView()
        containerView.backgroundColor = UIColor.white
    }
    
    func setupTitleLabelProperties() {
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.gray
        titleLabel.font = FontBook.AvenirMedium.of(size: 12)
    }
    
    func setupDateLabelProperties() {
        dateLabel = UILabel()
        dateLabel.textColor = UIColor.black
        dateLabel.font = FontBook.AvenirMedium.of(size: 12)
    }
    
    func setupLabelsStackViewProperties() {
        let views: [UILabel] = [titleLabel, dateLabel]
        labelsStackView = UIStackView(arrangedSubviews: views)
        labelsStackView.spacing = 4.0
        labelsStackView.axis = .vertical
    }
    
}

//MARK: Constraints Setup

extension ContestTableViewCell {
    
    func setupContainerViewConstraints() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.constrainEdges(to: self.contentView)
    }
    
    func setupCollectionViewConstraints() {
        containerView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setupStackViewConstraints() {
        containerView.addSubview(labelsStackView)
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15).isActive = true
        labelsStackView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -10).isActive = true
        labelsStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
    }
    
}
