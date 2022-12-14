import UIKit
import SnapKit
import RealmSwift

class InfoViewController: UIViewController, Storyboardable {
    
    var viewModel: InfoViewModel?
    var coordinator: AppCoordinator?
    
    var id = 0
    var name = ""
    var status = ""
    var species = ""
    var gender = ""
    var image = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var favouriteCharacters = [String]()
        id = viewModel?.id ?? 0
        name = viewModel?.name ?? ""
        status = viewModel?.status ?? ""
        species = viewModel?.species ?? ""
        gender = viewModel?.gender ?? ""
        image = viewModel?.image ?? ""
        
        initializate()
    }
    
    func initializate() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let titleLabel = UILabel()
        titleLabel.text = "Информация о персонаже"
        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 24)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(75)
            maker.centerX.equalToSuperview()
        }
        
        let nameLabel = UILabel()
        nameLabel.text = "Имя:"
        nameLabel.font = UIFont.systemFont(ofSize: screenWidth/20)
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel).inset(75)
            maker.left.equalToSuperview().inset(30)
        }
        
        let personNameLabel = UILabel()
        personNameLabel.text = name
        personNameLabel.font = UIFont.systemFont(ofSize: screenWidth/20)
        personNameLabel.textColor = .darkGray
        view.addSubview(personNameLabel)
        personNameLabel.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel).inset(75)
            maker.left.equalTo(nameLabel).inset(screenWidth / 3.5)
        }
        
        let statusLabel = UILabel()
        statusLabel.text = "Статус:"
        statusLabel.font = UIFont.systemFont(ofSize: screenWidth/20)
        view.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { maker in
            maker.top.equalTo(nameLabel).inset(50)
            maker.left.equalToSuperview().inset(30)
        }
        
        let personStatusLabel = UILabel()
        personStatusLabel.text = status
        personStatusLabel.font = UIFont.systemFont(ofSize: screenWidth/20)
        personStatusLabel.textColor = .darkGray
        view.addSubview(personStatusLabel)
        personStatusLabel.snp.makeConstraints { maker in
            maker.top.equalTo(nameLabel).inset(50)
            maker.left.equalTo(statusLabel).inset(screenWidth / 3.5)
        }
        
        let speciesLabel = UILabel()
        speciesLabel.text = "Вид:"
        speciesLabel.font = UIFont.systemFont(ofSize: screenWidth/20)
        view.addSubview(speciesLabel)
        speciesLabel.snp.makeConstraints { maker in
            maker.top.equalTo(statusLabel).inset(50)
            maker.left.equalToSuperview().inset(30)
        }
        
        let personSpeciesLabel = UILabel()
        personSpeciesLabel.text = species
        personSpeciesLabel.font = UIFont.systemFont(ofSize: screenWidth/20)
        personSpeciesLabel.textColor = .darkGray
        view.addSubview(personSpeciesLabel)
        personSpeciesLabel.snp.makeConstraints { maker in
            maker.top.equalTo(statusLabel).inset(50)
            maker.left.equalTo(speciesLabel).inset(screenWidth / 3.5)
        }
        
        let genderLabel = UILabel()
        genderLabel.text = "Пол:"
        genderLabel.font = UIFont.systemFont(ofSize: screenWidth/20)
        view.addSubview(genderLabel)
        genderLabel.snp.makeConstraints { maker in
            maker.top.equalTo(speciesLabel).inset(50)
            maker.left.equalToSuperview().inset(30)
        }
        
        let personGenderLabel = UILabel()
        personGenderLabel.text = gender
        personGenderLabel.font = UIFont.systemFont(ofSize: screenWidth/20)
        personGenderLabel.textColor = .darkGray
        view.addSubview(personGenderLabel)
        personGenderLabel.snp.makeConstraints { maker in
            maker.top.equalTo(speciesLabel).inset(50)
            maker.left.equalTo(genderLabel).inset(screenWidth / 3.5)
        }
        
        let personImage = UIImageView()
        let url = URL(string: image)
        if let data = try? Data(contentsOf: url!)
        {
            personImage.image = UIImage(data: data)
        }
        view.addSubview(personImage)
        personImage.snp.makeConstraints { maker in
            maker.top.equalTo(genderLabel).inset(50)
            maker.centerX.equalToSuperview().inset(30)
            maker.width.height.equalTo(screenWidth / 2)
        }
        
        let addToFavouritesButton = UIButton(type: .system)
        addToFavouritesButton.setTitle("Добавить в избранное", for: .normal)
        addToFavouritesButton.setTitleColor(.white, for: .normal)
        addToFavouritesButton.backgroundColor = UIColor(red: 84/255, green: 118/255, blue: 171/255, alpha: 1)
        addToFavouritesButton.layer.cornerRadius = 20
        view.addSubview(addToFavouritesButton)
        addToFavouritesButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(screenWidth * 0.6)
            maker.height.equalTo(screenHeight * 0.075)
            maker.bottom.equalToSuperview().inset(30)
        }
        addToFavouritesButton.addTarget(self, action: #selector(addToFavouritesButtonPressed), for: .touchUpInside)
    }
    
    @objc private func addToFavouritesButtonPressed() {
        
    }
}
