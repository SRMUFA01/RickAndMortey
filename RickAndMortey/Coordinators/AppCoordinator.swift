import UIKit

class AppCoordinator : Coordinator {
    var navigationController: UINavigationController
    var id = 0
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showMain()
    }
    
    func showMain() {
        let vc = MainViewController.createObject()
        let viewModel = MainViewModel()
        vc.coordinator = self
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showInfo(id: Int) {
        let vc = InfoViewController.createObject()
        let viewModel = InfoViewModel()
        viewModel.id = id
        vc.coordinator = self
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
}
