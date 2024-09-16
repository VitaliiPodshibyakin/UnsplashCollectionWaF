
import UIKit

class FavoritePhotosVC: UIViewController {
    
    // MARK: - Private properties
    
    private let tableView = UITableView()
    
    private let presenter: FavoritePhotosPresenterProtocol
    private var uiModel: FavoritePhotosVCUIModel = .init()
    
    // MARK: - Init
    
    public init(presenter: FavoritePhotosPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        presenter.performAction(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        presenter.performAction(.viewWillAppear)
    }
    
    // MARK: - Private methods
    private func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 300
        tableView.register(FavoritePhotosCell.self, forCellReuseIdentifier: "FavoritePhotosCell")
        tableView.pin(to: view)
    }
    
    private func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate
extension FavoritePhotosVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        uiModel.favoritePhotos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritePhotosCell") as? FavoritePhotosCell
        else { return .init() }
        
        let content = uiModel.favoritePhotos[indexPath.row].cellModel
        
        cell.configure(with: content)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        let selectedPhoto = uiModel.favoritePhotos[indexPath.row]
        presenter.performAction(.selectPhoto(id: selectedPhoto.id))
    }

}

// MARK: - FavoritePhotosVCProtocol

extension FavoritePhotosVC: FavoritePhotosVCProtocol {
    
    func updateView(_ uiModel: FavoritePhotosVCUIModel) {
        self.uiModel = uiModel
        self.tableView.reloadData()
    }
    
    func pushDetailedVC(with photo: UnsplashPhoto) {
        let presenter = DetailedInfoPresenter(photo: photo)
        let detailedInfoVC = DetailedInfoVC(presenter: presenter)
        presenter.view = detailedInfoVC
        self.navigationController?.pushViewController(detailedInfoVC, animated: true)
    }
    
}
