
protocol FavoritePhotosVCProtocol: AnyObject {
    
    func updateView(_ uiModel: FavoritePhotosVCUIModel)
    
    func pushDetailedVC(with photo: UnsplashPhoto)
    
}
