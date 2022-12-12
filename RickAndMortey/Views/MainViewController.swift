import UIKit
import SnapKit

class MainViewController: UIViewController, Storyboardable {
    
    var viewModel: MainViewModel?
    var coordinator: AppCoordinator?
    
    let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
    
    var data = ["Рик", "Морти", "Кто-то еще", "Рик", "Морти", "Кто-то еще", "Рик", "Морти", "Кто-то еще", "Рик", "Морти", "Кто-то еще", "Рик", "Морти", "Кто-то еще", "Рик", "Морти", "Кто-то еще"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Rick and Mortey"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        
        updateLayout(with: view.frame.size)
        
        addButton()
    }
    
    private func addButton() {
        let favouritesButton = UIButton(type: .system)
        favouritesButton.setTitle("★", for: .normal)
        favouritesButton.setTitleColor(.yellow, for: .normal)
        favouritesButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        favouritesButton.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
        favouritesButton.layer.borderWidth = 2
        favouritesButton.layer.borderColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        favouritesButton.layer.cornerRadius = 25
        view.addSubview(favouritesButton)
        favouritesButton.snp.makeConstraints { maker in
            maker.left.equalToSuperview().inset(25)
            maker.width.equalTo(75)
            maker.height.equalTo(75)
            maker.bottom.equalToSuperview().inset(25)
        }
    }
    
    private func updateLayout(with size: CGSize) {
        tableView.frame = CGRect.init(origin: .zero, size: size)
    }
   
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableView:
            return self.data.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.textLabel?.text = data[indexPath.row]
        //cell.imageView?.image = UIImage(named: "nameOfImage")
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
