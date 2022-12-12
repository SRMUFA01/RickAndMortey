import UIKit
import SnapKit

class InfoViewController: UIViewController, Storyboardable {
    
    var viewModel: InfoViewModel?
    var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializate()
    }
    
    func initializate() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let btn = UIButton()
        btn.setTitle("LOG IN →", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 84/255, green: 118/255, blue: 171/255, alpha: 1)
        btn.layer.cornerRadius = 20
        view.addSubview(btn)
        btn.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(screenWidth * 0.350)
            maker.height.equalTo(screenHeight * 0.075)
            maker.bottom.equalToSuperview().inset(100)
        }
        btn.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)
    }
    
    @objc private func btnPressed() {
        print("hi")
    }
}
