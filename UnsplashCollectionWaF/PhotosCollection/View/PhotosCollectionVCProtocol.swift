
protocol PhotosCollectionVCProtocol: AnyObject {
    
    func updateView(_ uiModel: PhotosCollectionUIModel)
    
    func pushDetailedVC(with photo: UnsplashPhoto)
    
}
