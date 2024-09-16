
import Foundation

final class PhotosCollectionPresenter {
    
    // MARK: - Public properties
    
    weak var view: PhotosCollectionVCProtocol?
    
    // MARK: - Private properties
    
    private let queue = DispatchQueue(label: "PhotosCollectionPresenter.queue")
    
    private let dataFetcher: DataFetcher
    private var photos: [UnsplashPhoto] = []
    
    
    // MARK: - Init
    
    init(dataFetcher: DataFetcher) {
        self.dataFetcher = dataFetcher
    }
    
    // MARK: - Private methods
    
    private func updateView(with model: PhotosCollectionUIModel) {
        DispatchQueue.main.async {
            self.view?.updateView(model)
        }
    }
    
    private func fetchRandomPhotos() {
        dataFetcher.fetchRandomImages { [weak self] photos in
            guard let self else { return }
            
            self.queue.async {
                self.photos = photos ?? []
                let uiModel = self.setupUIModel(for: self.photos)
                self.updateView(with: uiModel)
            }
        }
    }
    
    private func fetchSearch(with searchText: String) {
        dataFetcher.fetchImages(searchTerm: searchText) { [weak self] searchResults in
            guard
                let self,
                let searchResults
            else { return }
            
            self.queue.async {
                self.photos = searchResults.results ?? []
                let uiModel = self.setupUIModel(for: self.photos)
                self.updateView(with: uiModel)
            }
        }
    }
    
    private func setupUIModel(for photos: [UnsplashPhoto]) -> PhotosCollectionUIModel {
        var resultPhotos: [Photo] = []
        
        photos.forEach { photo in
            guard 
                let imageUrl = photo.urls?["small"],
                let url = URL(string: imageUrl)
            else { return }
            
            let cellModel = PhotoCellUIModel(
                imageSource: url
            )
            let resultPhoto = Photo(
                id: photo.id ?? "",
                cellModel: cellModel
            )
            resultPhotos.append(resultPhoto)
        }
        
        return .init(photos: resultPhotos)
    }
    
    private func selectPhoto(id: String) {
        guard
            let selectedPhoto = photos.first(where: { photo in
                photo.id == id
            })
        else { return }
        
        DispatchQueue.main.async {
            self.view?.pushDetailedVC(with: selectedPhoto)
        }
    }
    
}

extension PhotosCollectionPresenter: PhotosCollectionPresenterProtocol {
    
    func performAction(_ action: PhotosCollectionAction) {
        queue.async {
            switch action {
            case .viewDidLoad:
                self.fetchRandomPhotos()
            case let .search(searchText):
                self.fetchSearch(with: searchText)
            case let .selectPhoto(id):
                self.selectPhoto(id: id)
            }
        }
        
    }
    
}
