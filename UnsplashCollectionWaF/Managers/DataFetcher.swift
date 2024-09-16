
import Foundation

class DataFetcher {
    
    var networkService = NetworkManager()

    func fetchRandomImages(completion: @escaping ([UnsplashPhoto]?) -> ()) {
        networkService.requestForRandom { data, error in
            if let error = error {
                print("Error \(error.localizedDescription)")
                completion(nil)
            }
            let decode = self.decodeJSON(type: [UnsplashPhoto].self, data: data)
            completion(decode)
        }
    }
    
    func fetchImages(searchTerm: String, completion: @escaping (SearchPhotoResponse?) -> ()) {
        networkService.request(searchTerm: searchTerm) { data, error in
            if let error = error {
                print("Error \(error.localizedDescription)")
                completion(nil)
            }
            let decode = self.decodeJSON(type: SearchPhotoResponse.self, data: data)
            completion(decode)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, data: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = data else { return nil}
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let error {
            print("Failed to decode", error)
            return nil
        }
    }
}

