
import Kingfisher

class FavoritePhotosCell: UITableViewCell {
    
    let label: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    private let favoriteImageView: UIImageView = {
       let photo = UIImageView()
        photo.contentMode = .scaleAspectFit
        photo.clipsToBounds = true
        photo.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        return photo
    }()

    let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    public func configure(with model: FavoritePhotosCellUIModel){
        favoriteImageView.kf.setImage(with: model.imageSource)
        label.text = model.authorName
    }
    
    // MARK: - Private methods
    private func setupStackView() {
        
        stackView.addArrangedSubview(favoriteImageView)
        stackView.addArrangedSubview(label)
        contentView.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}

