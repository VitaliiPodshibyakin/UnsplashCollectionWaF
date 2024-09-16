
import Foundation

final class DetailedInfoPresenter {
    
    // MARK: - Public properties
    weak var view: DetailedInfoVCProtocol?
    
    // MARK: - Private properties
    private let photo: UnsplashPhoto
    private let queue = DispatchQueue(label: "DetailedInfoPresenter.queue")
    private var isSaved = false
    
    
    init(photo: UnsplashPhoto) {
        self.photo = photo
        
        self.isSaved = self.checkIsSaved(photo: self.photo)
    }
    
    private func updateView(with model: DetailedInfoVCUIModel) {
        DispatchQueue.main.async {
            self.view?.updateView(model)
        }
    }
    
    private func isSavedUpdate() {
        isSaved = StorageManager.shared.checkIfObjectExists(photo: photo)
    }
    
    private func setupUIModel(photo: UnsplashPhoto, isSaved: Bool) -> DetailedInfoVCUIModel {
        let photoURL = photo.urls?["small"] ?? "no data"
        let model = DetailedInfoVCUIModel(
            photoURL: URL(string: photoURL) ?? URL(fileURLWithPath: ""),
            authorName: photo.user?.name ?? "no data",
            date: photo.createdAt ?? "no data",
            location: photo.location?.name ?? "no data",
            downloads: photo.downloads ?? 0,
            buttonModel: setupButtonModel(isSaved: isSaved)
        )
        
        return model
    }
    
    private func setupButtonModel(isSaved: Bool) -> ButtonUIModel {
        let title: String
        let state: ButtonState
        
        if isSaved {
            title = "Remove from favorites"
            state = .delete
        } else {
            title = "Save to favorites"
            state = .save
        }
        
        return ButtonUIModel(title: title, state: state)
    }
    
    private func savePhoto() {
            StorageManager.shared.save(photo: photo)
        isSaved.toggle()
    }
    private func deletePhoto() {
            StorageManager.shared.deletePhotosFromFav(photo: photo)
        isSaved.toggle()
    }
    
    private func checkIsSaved(photo: UnsplashPhoto) -> Bool {
        StorageManager.shared.checkIfObjectExists(photo: photo)
    }
}

extension DetailedInfoPresenter: DetailedInfoPresenterProtocol {
    func performAction(_ action: DetailedInfoAction) {
        
        queue.async {
            switch action {
                
            case .viewDidLoad:
                let uiModel = self.setupUIModel(photo: self.photo, isSaved: self.isSaved)
                self.updateView(with: uiModel)
                
            case .buttonTapped:
                if self.isSaved {
                    self.deletePhoto()
                    
                } else {
                    self.savePhoto()
                }
                let uiModel = self.setupUIModel(photo: self.photo, isSaved: self.isSaved)
                self.updateView(with: uiModel)
                
            case .viewWillAppear:
                self.isSaved = self.checkIsSaved(photo: self.photo)
                let uiModel = self.setupUIModel(photo: self.photo, isSaved: self.isSaved)
                self.updateView(with: uiModel)
            }
        }
    }
}
