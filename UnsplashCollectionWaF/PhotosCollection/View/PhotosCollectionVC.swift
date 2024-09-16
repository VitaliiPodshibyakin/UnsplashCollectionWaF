
import UIKit

class PhotosCollectionVC: UIViewController {
    
    private enum Const {
        static var itemsPerRow: CGFloat = 3
        static var sectionInsets = UIEdgeInsets(
            top: 10, 
            left: 10,
            bottom: 10,
            right: 10
        )
    }
    
    // MARK: - Subviews
    
    private let randomPhotosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    // MARK: - Private properties
    
    private let presenter: PhotosCollectionPresenterProtocol
    private var uiModel: PhotosCollectionUIModel = .init()
    
    // MARK: - Init
    
    public init(presenter: PhotosCollectionPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSearchBar()
        
        presenter.performAction(.viewDidLoad)
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        view.addSubview(randomPhotosCollectionView)
        randomPhotosCollectionView.pin(to: view)
        randomPhotosCollectionView.delegate = self
        randomPhotosCollectionView.dataSource = self
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }

}

// MARK: - UICollectionViewDelegate
extension PhotosCollectionVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView, 
        numberOfItemsInSection section: Int
    ) -> Int {
        uiModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "cell",
                for: indexPath
            ) as? PhotosCollectionViewCell
        else { return .init() }
        
        let cellUIModel = uiModel.photos[indexPath.item].cellModel
        cell.configure(with: cellUIModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Const.sectionInsets.left * (Const.itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / Const.itemsPerRow
        
        return CGSize(width: widthPerItem, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        Const.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhoto = uiModel.photos[indexPath.item]
        
        presenter.performAction(.selectPhoto(id: selectedPhoto.id))
    }
}

// MARK: - UISearchDelegate

extension PhotosCollectionVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.performAction(.search(searchText))
    }
}

// MARK: - PhotosCollectionVCProtocol

extension PhotosCollectionVC: PhotosCollectionVCProtocol {
    
    func updateView(_ uiModel: PhotosCollectionUIModel) {
        self.uiModel = uiModel
        self.randomPhotosCollectionView.reloadData()
    }
    
    func pushDetailedVC(with photo: UnsplashPhoto) {
        let presenter = DetailedInfoPresenter(photo: photo)
        let detailedInfoVC = DetailedInfoVC(presenter: presenter)
        presenter.view = detailedInfoVC
        self.navigationController?.pushViewController(detailedInfoVC, animated: true)
    }
    
}

