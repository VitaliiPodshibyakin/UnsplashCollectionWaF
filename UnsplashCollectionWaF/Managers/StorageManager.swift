
import Foundation

class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let key = "photos"
    
    private init() {}
    
    func save(photo: UnsplashPhoto) {
        var photos = fetchPhotos()
        photos.append(photo)
        guard let data = try? JSONEncoder().encode(photos) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func fetchPhotos() -> [UnsplashPhoto] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        guard let photos = try? JSONDecoder().decode([UnsplashPhoto].self, from: data) else { return [] }
        return photos
    }
    
    func deletePhotos(at index: Int) {
        var photos = fetchPhotos()
        photos.remove(at: index)
        guard let data = try? JSONEncoder().encode(photos) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func deletePhotosFromFav(photo: UnsplashPhoto) {
        var photos = fetchPhotos()
        guard let photoIndex = photos.firstIndex(where: { $0.id == photo.id }) else { return }
        photos.remove(at: photoIndex)
        guard let data = try? JSONEncoder().encode(photos) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func checkIfObjectExists(photo: UnsplashPhoto) -> Bool {
        let photosList = fetchPhotos()
        return photosList.contains(where: { $0.id == photo.id })
    }
    
}
