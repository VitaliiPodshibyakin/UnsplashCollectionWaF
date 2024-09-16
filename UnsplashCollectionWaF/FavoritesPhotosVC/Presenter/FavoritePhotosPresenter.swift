
import Foundation

final class FavoritePhotosPresenter {
    
    // MARK: - Public properties
    
    weak var view: FavoritePhotosVCProtocol?
    
    // MARK: - Private properties
    
    private let queque = DispatchQueue(label: "FavoritePhotosPresenter.queue")
    private var favoritePhotos: [UnsplashPhoto] = []
    

    // MARK: - Private methods
    
    private func updateView(with model: FavoritePhotosVCUIModel) {
        DispatchQueue.main.async {
            self.view?.updateView(model)
        }
    }
    private func setupUIModel(for photos: [UnsplashPhoto]) -> FavoritePhotosVCUIModel {
        var resultPhotos: [FavoritePhoto] = []
        
        favoritePhotos.forEach { favoritePhoto in
            guard
                let imageUrl = favoritePhoto.urls?["small"],
                let url = URL(string: imageUrl)
            else { return }
            
            let cellModel = FavoritePhotosCellUIModel(
                imageSource: url, authorName: favoritePhoto.user?.name ?? ""
            )
            let resultPhoto = FavoritePhoto(id: favoritePhoto.id ?? "", authorName: favoritePhoto.user?.name ?? "", cellModel: cellModel)
            resultPhotos.append(resultPhoto)
        }
        
        return .init(favoritePhotos: resultPhotos)
    }
    
    private func fetchFavoritesPhotos() {
        self.queque.async {
            let favoritePhotos = StorageManager.shared.fetchPhotos()
            self.favoritePhotos = favoritePhotos
            let uiModel = self.setupUIModel(for: self.favoritePhotos)
            self.updateView(with: uiModel)
        }

    }
    
    private func selectPhoto(id: String) {
        guard
            let selectedPhoto = favoritePhotos.first(where: { favoritePhoto in
                favoritePhoto.id == id
            })
        else { return }
        
        DispatchQueue.main.async {
            self.view?.pushDetailedVC(with: selectedPhoto)
        }
    }
    
}

extension FavoritePhotosPresenter: FavoritePhotosPresenterProtocol {
    
    func performAction(_ action: FavoritePhotosAction) {
        queque.async {
            switch action{
            case .viewDidLoad:
                self.fetchFavoritesPhotos()
            case .selectPhoto(id: let id):
                self.selectPhoto(id: id)
            case .viewWillAppear:
                self.fetchFavoritesPhotos()
            }
        }
    }
}
