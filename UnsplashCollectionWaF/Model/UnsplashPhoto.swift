
struct UnsplashPhoto: Codable {
    
    let id: String?
    let urls: [URLKind.RawValue: String]?
    let createdAt: String?
    let downloads: Int?
    let location: Location?
    let user: User?
    
    enum URLKind: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case downloads
        case location
        case user
        case urls
        case id
    }
}



struct Location: Codable {
    let name: String?
}

struct User: Codable {
    let name: String?
}
