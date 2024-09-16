
import UIKit

class TabBarController: UITabBarController {
    
    var photosCollectionVC: PhotosCollectionVC?
    var favoritePhotosVC: FavoritePhotosVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        
        //Photos collection VC
        let dataFetcher = DataFetcher()
        let photosCollectionPresenter = PhotosCollectionPresenter(dataFetcher: dataFetcher)
        let photosCollectionVC = PhotosCollectionVC(presenter: photosCollectionPresenter)
        photosCollectionPresenter.view = photosCollectionVC
        
        self.photosCollectionVC = photosCollectionVC
        let navPhotosCollectionPhotoVC = UINavigationController(rootViewController: photosCollectionVC)
        photosCollectionVC.title = "Photo Collection"

        
        //Favorite VC
        let favoritePhotosPresenter = FavoritePhotosPresenter()
        let favoritePhotosVC = FavoritePhotosVC(presenter: favoritePhotosPresenter)
        favoritePhotosPresenter.view = favoritePhotosVC
        let navFavoritePhotoVC = UINavigationController(rootViewController: favoritePhotosVC)
        favoritePhotosVC.title = "Favorite photos"

        
        
        setViewControllers([navPhotosCollectionPhotoVC, navFavoritePhotoVC], animated: false)
        
        guard let items = tabBar.items else { return }
        items[0].image = UIImage(systemName: "photo")
        items[1].image = UIImage(systemName: "star")
        
    }
}

