import UIKit
import SnapKit

class MainViewController: UIViewController, Storyboardable {
    
    let networkService = NetworkService()
    var viewModel: MainViewModel?
    var coordinator: AppCoordinator?
    var dataResponse: DataResponse? = nil
    var timer: Timer?
    
    let charURL = "https://rickandmortyapi.com/api/character/"
    
    let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
        
        addButton()
        
        networkRequest(url: charURL)
    }
    
    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    func setupTableView() {
        navigationItem.title = "Rick and Mortey"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        updateLayout(with: view.frame.size)
    }
    
    private func updateLayout(with size: CGSize) {
        tableView.frame = CGRect.init(origin: .zero, size: size)
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
    
    func networkRequest(url: String) {
        networkService.request(dataURL: url) { [weak self] (result) in
            switch result {
            case .success(let dataResponse):
                dataResponse.results.map { (characterData) in
                    self?.dataResponse = dataResponse
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("error:", error)
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableView:
            return self.dataResponse?.results.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let data = dataResponse?.results[indexPath.row]
        cell.textLabel?.text = data?.name
        let url = URL(string: data?.image ?? "")
        if let data = try? Data(contentsOf: url!)
        {
            cell.imageView?.image = UIImage(data: data)
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = dataResponse?.results[indexPath.row]
        let id = data?.id
        let name = data?.name
        let status = data?.status
        let species = data?.species
        let gender = data?.gender
        let image = data?.image
        coordinator?.id = viewModel?.id.value ?? 0
        coordinator?.name = viewModel?.name.value ?? ""
        coordinator?.status = viewModel?.status.value ?? ""
        coordinator?.species = viewModel?.species.value ?? ""
        coordinator?.gender = viewModel?.gender.value ?? ""
        coordinator?.image = viewModel?.image.value ?? ""
        coordinator?.showInfo(id: id ?? 0, name: name ?? "", status: status ?? "", species: species ?? "", gender: gender ?? "", image: image ?? "")
    }
}

extension MainViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let dataURL = "https://rickandmortyapi.com/api/character/?name=\(searchText)"
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkRequest(url: dataURL)
        })
    }
}
