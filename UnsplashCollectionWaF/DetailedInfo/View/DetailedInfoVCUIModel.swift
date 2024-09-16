
import Foundation

struct DetailedInfoVCUIModel {
    
    var photoURL: URL
    var authorName: String
    var date: String
    var location: String
    var downloads: Int
    var buttonModel: ButtonUIModel
    
}

struct ButtonUIModel {
    var title: String
    var state: ButtonState
}

enum ButtonState {
    case save
    case delete
}
