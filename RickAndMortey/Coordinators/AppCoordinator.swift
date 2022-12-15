import UIKit
import RealmSwift

class AppCoordinator : Coordinator {
    var navigationController: UINavigationController
    var id = 0
    var name = ""
    var status = ""
    var species = ""
    var gender = ""
    var image = ""
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: Открытие основного окна
    func showMain() {
        let vc = MainViewController.createObject()
        let viewModel = MainViewModel()
        vc.coordinator = self
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    // MARK: Открытие информации о персонаже
    func showInfo(id: Int, name: String, status: String, species: String, gender: String, image: String) {
        let vc = InfoViewController.createObject()
        let viewModel = InfoViewModel()
        viewModel.id = id
        viewModel.name = name
        viewModel.status = status
        viewModel.species = species
        viewModel.gender = gender
        viewModel.image = image
        vc.coordinator = self
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
}
