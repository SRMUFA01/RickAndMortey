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
        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 18)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(125)
            maker.centerX.equalToSuperview()
        }
        
        nameLabel.text = "Имя:"
        nameLabel.font = UIFont.systemFont(ofSize: screenWidth/25)
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel).inset(100)
            maker.left.equalToSuperview().inset(30)
        }
        
        personNameLabel.text = name
        personNameLabel.font = UIFont.systemFont(ofSize: screenWidth/25)
        view.addSubview(personNameLabel)
        personNameLabel.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel).inset(100)
            maker.left.equalTo(nameLabel).inset(screenWidth / 3)
        }
        
        statusLabel.text = "Статус:"
        statusLabel.font = UIFont.systemFont(ofSize: screenWidth/25)
        view.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { maker in
            maker.top.equalTo(nameLabel).inset(50)
            maker.left.equalToSuperview().inset(30)
        }
        
        personStatusLabel.text = status
        personStatusLabel.font = UIFont.systemFont(ofSize: screenWidth/25)
        view.addSubview(personStatusLabel)
        personStatusLabel.snp.makeConstraints { maker in
            maker.top.equalTo(nameLabel).inset(50)
            maker.left.equalTo(statusLabel).inset(screenWidth / 3)
        }
        
        speciesLabel.text = "Вид персонажа:"
        speciesLabel.font = UIFont.systemFont(ofSize: screenWidth/25)
        view.addSubview(speciesLabel)
        speciesLabel.snp.makeConstraints { maker in
            maker.top.equalTo(statusLabel).inset(50)
            maker.left.equalToSuperview().inset(30)
        }
        
        personSpeciesLabel.text = species
        personSpeciesLabel.font = UIFont.systemFont(ofSize: screenWidth/25)
        view.addSubview(personSpeciesLabel)
        personSpeciesLabel.snp.makeConstraints { maker in
            maker.top.equalTo(statusLabel).inset(50)
            maker.left.equalTo(speciesLabel).inset(screenWidth / 3)
        }
        
        genderLabel.text = "Пол:"
        genderLabel.font = UIFont.systemFont(ofSize: screenWidth/25)
        view.addSubview(genderLabel)
        genderLabel.snp.makeConstraints { maker in
            maker.top.equalTo(speciesLabel).inset(50)
            maker.left.equalToSuperview().inset(30)
        }
        
        personGenderLabel.text = gender
        personGenderLabel.font = UIFont.systemFont(ofSize: screenWidth/25)
        view.addSubview(personGenderLabel)
        personGenderLabel.snp.makeConstraints { maker in
            maker.top.equalTo(speciesLabel).inset(50)
            maker.left.equalTo(genderLabel).inset(screenWidth / 3)
        }
        
        let btn = UIButton(type: .system)
        btn.setTitle("Добавить в избранное", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 84/255, green: 118/255, blue: 171/255, alpha: 1)
        btn.layer.cornerRadius = 20
        view.addSubview(btn)
        btn.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(screenWidth * 0.6)
            maker.height.equalTo(screenHeight * 0.075)
            maker.bottom.equalToSuperview().inset(100)
        }
        btn.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)
    }
    
    @objc private func btnPressed() {
        
    }
}
