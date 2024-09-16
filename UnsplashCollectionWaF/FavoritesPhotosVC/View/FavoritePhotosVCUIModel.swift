
import Foundation

struct FavoritePhotosVCUIModel {
    
    var favoritePhotos: [FavoritePhoto] = []
    
}

struct FavoritePhoto {
    
    var id: String
    var authorName: String
    var cellModel: FavoritePhotosCellUIModel
}
