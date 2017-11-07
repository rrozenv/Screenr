
import Foundation
import UIKit
import Kingfisher

final class DisplayedTheatreSearchCell: UITableViewCell {
    
    // MARK: - Type Properties
    
    static let reuseIdentifier = "DisplayedTheatreSearchCell"
    
    // MARK: - Properties
    
    fileprivate var containerView: UIView!
    fileprivate var posterImageView: UIImageView!
    fileprivate var nameLabel: UILabel!
    fileprivate var addressLabel: UILabel!
    
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
        self.contentView.backgroundColor = UIColor.white
        setupContainerView()
        setupImageView()
        setupNameLabel()
    }
    
    func configure(with displayedTheatre: MoviesSearch.Theatres.ViewModel.DisplayedTheatre) {
        self.selectionStyle = .none
        nameLabel.text = displayedTheatre.name
        addressLabel.text = "284 Main St., New York 10016"
//        if let posterURL = URL(string: displayedMovie.posterURL) {
//            posterImageView.kf.setImage(with: posterURL)
//        }
    }
    
    override func prepareForReuse() {
        containerView.backgroundColor = UIColor.white
    }
    
    fileprivate func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = UIColor.white
        contentView.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func setupImageView() {
        posterImageView = UIImageView()
        posterImageView.contentMode = .scaleAspectFill
        
        containerView.addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        posterImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        posterImageView.widthAnchor.constraint(equalToConstant: 46).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: 54).isActive = true
    }
    
    func setupNameLabel() {
        nameLabel = UILabel()
        nameLabel.font = UIFont(name: "Avenir-Medium", size: 12)
        nameLabel.textColor = UIColor.black
        
        addressLabel = UILabel()
        addressLabel.font = UIFont(name: "Avenir-Medium", size: 12)
        addressLabel.textColor = UIColor.gray
        addressLabel.numberOfLines = 1
        addressLabel.lineBreakMode = .byTruncatingTail
        
        let labels: [UILabel] = [nameLabel, addressLabel]
        let labelsStack = UIStackView(arrangedSubviews: labels)
        labelsStack.spacing = 4.0
        labelsStack.axis = .vertical
        
        containerView.addSubview(labelsStack)
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20).isActive = true
        labelsStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    }
    
}

final class DisplayedMovieSearchCell: UITableViewCell {
    
    // MARK: - Type Properties
    
    static let reuseIdentifier = "DisplayedMovieSearchCell"
    
    // MARK: - Properties
    
    fileprivate var containerView: UIView!
    fileprivate var posterImageView: UIImageView!
    fileprivate var nameLabel: UILabel!
    fileprivate var yearLabel: UILabel!
    
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
        self.contentView.backgroundColor = UIColor.white
        setupContainerView()
        setupImageView()
        setupNameLabel()
    }
    
    func configure(with displayedMovie: DisplayedMovieInSearch) {
        self.selectionStyle = .none
        nameLabel.text = displayedMovie.title
        yearLabel.text = displayedMovie.year
        if let posterURL = URL(string: displayedMovie.posterURL) {
            posterImageView.kf.setImage(with: posterURL)
        }
    }
    
    override func prepareForReuse() {
        containerView.backgroundColor = UIColor.white
    }
    
    fileprivate func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = UIColor.white
        contentView.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func setupImageView() {
        posterImageView = UIImageView()
        posterImageView.contentMode = .scaleAspectFill
        
        containerView.addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        posterImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        posterImageView.widthAnchor.constraint(equalToConstant: 46).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: 54).isActive = true
    }
    
    func setupNameLabel() {
        nameLabel = UILabel()
        nameLabel.font = UIFont(name: "Avenir-Medium", size: 12)
        nameLabel.textColor = UIColor.black
        
        yearLabel = UILabel()
        yearLabel.font = UIFont(name: "Avenir-Medium", size: 12)
        yearLabel.textColor = UIColor.gray
        yearLabel.numberOfLines = 1
        yearLabel.lineBreakMode = .byTruncatingTail
        
        let labels: [UILabel] = [nameLabel, yearLabel]
        let labelsStack = UIStackView(arrangedSubviews: labels)
        labelsStack.spacing = 4.0
        labelsStack.axis = .vertical
        
        containerView.addSubview(labelsStack)
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20).isActive = true
        labelsStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    }
    
}

final class TextFieldCell: UITableViewCell {
    
    // MARK: - Type Properties
    enum Style: String {
        case price = "TICKET PRICE"
        case votes = "# VOTES REQUIRED TO WIN"
        
        var defaultValue: String {
            switch self {
            case .price:
                return "$ 10"
            case .votes:
                return "20"
            }
        }
    }
    
    static let reuseIdentifier = "TextFieldCell"
    
    // MARK: - Properties
    
    fileprivate var containerView: UIView!
    fileprivate var titleLabel: UILabel!
    fileprivate var userInputLabel: UILabel!
    
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
        setupContainerView()
        setupTitleLabel()
        setupUserInputLabel()
        setupLabelsStackView()
    }
    
    func configure(with style: Style, inputValue: String?) {
        self.selectionStyle = .none
        titleLabel.text = style.rawValue
        userInputLabel.text = inputValue ?? style.defaultValue
    }
    
    override func prepareForReuse() {
        containerView.backgroundColor = UIColor.white
    }
    
    fileprivate func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = UIColor.white
        contentView.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Avenir-Medium", size: 12)
        titleLabel.textColor = UIColor.gray
    }
    
    func setupUserInputLabel() {
        userInputLabel = UILabel()
        userInputLabel.font = UIFont(name: "Avenir-Medium", size: 12)
        userInputLabel.textColor = UIColor.black
    }
    
    func setupLabelsStackView() {
        let labels: [UILabel] = [titleLabel, userInputLabel]
        let labelsStack = UIStackView(arrangedSubviews: labels)
        labelsStack.spacing = 4.0
        labelsStack.axis = .vertical
        
        containerView.addSubview(labelsStack)
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        labelsStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    }
    
}

final class DateCell: UITableViewCell {
    
    // MARK: - Type Properties
    static let reuseIdentifier = "DateCell"
    
    // MARK: - Properties
    
    fileprivate var containerView: UIView!
    fileprivate var titleLabel: UILabel!
    var dateButton: UIButton!
    fileprivate var timeButton: UIButton!
    
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
        setupContainerView()
        setupTitleLabel()
        setupDateButton()
        //setupLabelsStackView()
    }
    
    func configure() {
        self.selectionStyle = .none
        dateButton.titleLabel?.text = Date().yearMonthDayString
    }
    
    override func prepareForReuse() {
        containerView.backgroundColor = UIColor.white
    }
    
    fileprivate func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = UIColor.white
        contentView.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Avenir-Medium", size: 12)
        titleLabel.textColor = UIColor.gray
    }
    
    func setupDateButton() {
        dateButton = UIButton()
        dateButton.backgroundColor = UIColor.blue
        dateButton.titleLabel?.textColor = UIColor.black
        
        containerView.addSubview(dateButton)
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        dateButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dateButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        dateButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        dateButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
    }
    
    func setupLabelsStackView() {
        let labels: [UIView] = [titleLabel, dateButton]
        let labelsStack = UIStackView(arrangedSubviews: labels)
        labelsStack.spacing = 4.0
        labelsStack.axis = .vertical
        
        containerView.addSubview(labelsStack)
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        labelsStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    }
    
}
