
import Kingfisher

class DetailedInfoVC: UIViewController {
    
    lazy var addToFavButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(favButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center

        return label
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    // MARK: - Private properties
    
    private let presenter: DetailedInfoPresenterProtocol
    private var uiModel: DetailedInfoVCUIModel = .init(photoURL: URL(fileURLWithPath: ""), authorName: "", date: "", location: "", downloads: 0, buttonModel: .init(title: "", state: .delete))
    
    
    // MARK: - Init
    
    init(presenter: DetailedInfoPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        presenter.performAction(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.performAction(.viewWillAppear)
    }

    @objc func favButtonTapped() {
        showAlert()
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "Yep", style: .default) { _ in
                self.presenter.performAction(.buttonTapped)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
}

// MARK: - Setup UI

extension DetailedInfoVC {
    
    private func setupLayout() {
        
        view.addSubview(imageView)
        view.addSubview(addToFavButton)
        view.addSubview(label)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        addToFavButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 350),
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),

            addToFavButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addToFavButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
    
    private func configureButton(model: ButtonUIModel) {
        addToFavButton.setTitle(model.title, for: .normal)
        switch model.state {
        case .save:
            addToFavButton.setTitleColor(.systemBlue, for: .normal)
        case .delete:
            addToFavButton.setTitleColor(.systemRed, for: .normal)
            
        }
    }
}


extension DetailedInfoVC: DetailedInfoVCProtocol {
    
    func updateView(_ uiModel: DetailedInfoVCUIModel) {
        
        configureButton(model: uiModel.buttonModel)
        
        label.text = "Author: \(uiModel.authorName) \nCreated at: \(uiModel.date) \nLocation: \(uiModel.location) \nDownloads: \(uiModel.downloads)"
        
        imageView.kf.setImage(with: uiModel.photoURL)
        
    }
    
}
