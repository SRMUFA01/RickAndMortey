import UIKit
import SnapKit

class MainViewController: UIViewController, Storyboardable {
    
    let networkService = NetworkService()
    var viewModel: MainViewModel?
    var coordinator: AppCoordinator?
    var dataResponse: DataResponse? = nil
    var timer: Timer?
    var favouritesButton = UIBarButtonItem()
    
    let charURL = "https://rickandmortyapi.com/api/character/"
    var favouritesURL = ""
    let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
    
    var isFavourite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let favouritesArray = [23, 12, 14]
        var favourites = ""
        for i in favouritesArray {
            favourites += String(i)
            if i != favouritesArray[favouritesArray.count - 1] {
                favourites += ","
            }
        }
        
        favouritesURL = "https://rickandmortyapi.com/api/character/\(favourites)"
        print(favouritesURL)
        setupFavouritesButton()
        setupSearchBar()
        setupTableView()
        
        
        networkRequest(url: charURL)
    }
    
    
    func setupFavouritesButton() {
        favouritesButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(isFavouritesButtonPressed))
        navigationItem.rightBarButtonItem = favouritesButton
        
        
    }
    
    @objc func isFavouritesButtonPressed() {
        if isFavourite {
            isFavourite = false
            navigationItem.title = "Rick and Mortey"
            networkRequest(url: charURL)
        }
        else {
            isFavourite = true
            navigationItem.title = "Избранное"
            networkRequest(url: favouritesURL)
        }
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
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        updateLayout(with: view.frame.size)
    }
    
    private func updateLayout(with size: CGSize) {
        tableView.frame = CGRect.init(origin: .zero, size: size)
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
