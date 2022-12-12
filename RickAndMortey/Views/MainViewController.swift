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
        request { dataResponse, error in
            dataResponse?.results.map({ (characterData) in
                print(characterData.name)
            })
        }
    }
    
    func request(completion: @escaping (DataResponse?, Error?) -> Void) {
        let dataURL = "https://rickandmortyapi.com/api/character/"
        guard let url = URL(string: dataURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("error")
                    completion(nil, error)
                    return
                }
                guard let data = data else { return }
                do {
                    let characterData = try JSONDecoder().decode(DataResponse.self, from: data)
                    completion(characterData, nil)
                } catch let jsonError {
                    print("Ошибка: ", jsonError)
                    completion(nil, error)
                }
            }
        }.resume()
    }
    
    private func addButton() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        let favouritesButton = UIButton(type: .system)
        favouritesButton.setTitle("★", for: .normal)
        favouritesButton.setTitleColor(.black, for: .normal)
        favouritesButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        favouritesButton.backgroundColor = UIColor(red: 55/255, green: 220/255, blue: 100/255, alpha: 0.8)
        favouritesButton.layer.borderWidth = 2
        favouritesButton.layer.borderColor = UIColor(red: 20/255, green: 100/255, blue: 40/255, alpha: 1).cgColor
        favouritesButton.layer.cornerRadius = screenWidth * 0.2 / 2
        favouritesButton.layer.masksToBounds = true
        favouritesButton.clipsToBounds = true
        view.addSubview(favouritesButton)
        favouritesButton.snp.makeConstraints { maker in
            maker.left.equalToSuperview().inset(25)
            maker.width.equalTo(screenWidth * 0.2)
            maker.height.equalTo(screenWidth * 0.2)
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
