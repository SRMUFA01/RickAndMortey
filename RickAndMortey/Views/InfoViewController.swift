import UIKit
import SnapKit

class InfoViewController: UIViewController, Storyboardable {
    
    var viewModel: InfoViewModel?
    var coordinator: AppCoordinator?
    
    var id = 0
    var name = ""
    var status = ""
    var species = ""
    var gender = ""
    var image = ""
    
    let titleLabel = UILabel()
    let nameLabel = UILabel()
    let personNameLabel = UILabel()
    let statusLabel = UILabel()
    let personStatusLabel = UILabel()
    let speciesLabel = UILabel()
    let personSpeciesLabel = UILabel()
    let genderLabel = UILabel()
    let personGenderLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        id = viewModel?.id ?? 0
        name = viewModel?.name ?? ""
        status = viewModel?.status ?? ""
        species = viewModel?.species ?? ""
        gender = viewModel?.gender ?? ""
        image = viewModel?.image ?? ""
        
        print(image)
        initializate()
    }
    
    func initializate() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        titleLabel.text = "Информация о персонаже"
        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 24)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(125)
            maker.centerX.equalToSuperview()
        }
        
        nameLabel.text = "Имя:"
        nameLabel.font = UIFont.systemFont(ofSize: screenWidth/20)
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel).inset(100)
            maker.left.equalToSuperview().inset(30)
        }
        
        personNameLabel.text = name
        personNameLabel.font = UIFont.systemFont(ofSize: screenWidth/20)
        personNameLabel.textColor = .darkGray
        view.addSubview(personNameLabel)
        personNameLabel.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel).inset(100)
            maker.left.equalTo(nameLabel).inset(screenWidth / 2.25)
        }
        
        statusLabel.text = "Статус:"
        statusLabel.font = UIFont.systemFont(ofSize: screenWidth/20)
        view.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { maker in
            maker.top.equalTo(nameLabel).inset(50)
            maker.left.equalToSuperview().inset(30)
        }
        
        personStatusLabel.text = status
        personStatusLabel.font = UIFont.systemFont(ofSize: screenWidth/20)
        personStatusLabel.textColor = .darkGray
        view.addSubview(personStatusLabel)
        personStatusLabel.snp.makeConstraints { maker in
            maker.top.equalTo(nameLabel).inset(50)
            maker.left.equalTo(statusLabel).inset(screenWidth / 2.25)
        }
        
        speciesLabel.text = "Вид персонажа:"
        speciesLabel.font = UIFont.systemFont(ofSize: screenWidth/20)
        view.addSubview(speciesLabel)
        speciesLabel.snp.makeConstraints { maker in
            maker.top.equalTo(statusLabel).inset(50)
            maker.left.equalToSuperview().inset(30)
        }
        
        personSpeciesLabel.text = species
        personSpeciesLabel.font = UIFont.systemFont(ofSize: screenWidth/20)
        personSpeciesLabel.textColor = .darkGray
        view.addSubview(personSpeciesLabel)
        personSpeciesLabel.snp.makeConstraints { maker in
            maker.top.equalTo(statusLabel).inset(50)
            maker.left.equalTo(speciesLabel).inset(screenWidth / 2.25)
        }
        
        genderLabel.text = "Пол:"
        genderLabel.font = UIFont.systemFont(ofSize: screenWidth/20)
        view.addSubview(genderLabel)
        genderLabel.snp.makeConstraints { maker in
            maker.top.equalTo(speciesLabel).inset(50)
            maker.left.equalToSuperview().inset(30)
        }
        
        personGenderLabel.text = gender
        personGenderLabel.font = UIFont.systemFont(ofSize: screenWidth/20)
        personGenderLabel.textColor = .darkGray
        view.addSubview(personGenderLabel)
        personGenderLabel.snp.makeConstraints { maker in
            maker.top.equalTo(speciesLabel).inset(50)
            maker.left.equalTo(genderLabel).inset(screenWidth / 2.25)
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
            maker.bottom.equalToSuperview().inset(100)
        }
        addToFavouritesButton.addTarget(self, action: #selector(addToFavouritesButtonPressed), for: .touchUpInside)
    }
    
    @objc private func addToFavouritesButtonPressed() {
        
    }
}
