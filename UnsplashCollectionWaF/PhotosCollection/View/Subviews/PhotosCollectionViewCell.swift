

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
       let photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        photo.backgroundColor = .lightGray
        return photo
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    public func configure(with model: PhotoCellUIModel) {
        imageView.kf.setImage(with: model.imageSource)
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
}
