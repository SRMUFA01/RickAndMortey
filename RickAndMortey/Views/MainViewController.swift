import UIKit
import SnapKit
import RealmSwift

class MainViewController: UIViewController, Storyboardable {
    let realm = try! Realm()
    
    let networkService = NetworkService()
    var viewModel: MainViewModel?
    var coordinator: AppCoordinator?
    var dataResponse: DataResponse? = nil
    var charResponse: CharacterData? = nil
    var favouriteCharactersData = [CharacterData?]()
    var timer: Timer?
    var favouritesButton = UIBarButtonItem()
    
    let charURL = "https://rickandmortyapi.com/api/character/"
    
    let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
    
    var isFavourite = false
    var favouritesArray = [""]
    var iArray = [Int()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateFavourites()
        setupFavouritesButton()
        setupSearchBar()
        setupTableView()
        makeRequest()
        networkRequest(url: charURL)
    }
    
    func updateFavourites() {
        let favouriteObjects = realm.objects(FavouriteCharacters.self)
        if favouriteObjects.count != 0 {
            for i in 1..<(favouriteObjects.count) {
                if favouritesArray.contains(realm.objects(FavouriteCharacters.self)[i].id) { }
                else { favouritesArray.append(realm.objects(FavouriteCharacters.self)[i].id) }
            }
        }
    }
    
    func makeRequest() {
        updateFavourites()
        
        for i in 1..<(favouritesArray.count) {
            if iArray.contains(i) { }
            else {
                let favouritesURL = "https://rickandmortyapi.com/api/character/\(favouritesArray[i])"
                
                let request = URLRequest(url: URL(string: favouritesURL)!)
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data, let charData = try? JSONDecoder().decode(CharacterData.self, from: data) {
                        self.favouriteCharactersData.append(charData)
                        self.tableView.reloadData()
                    }
                    self.iArray.append(i)
                }
                task.resume()
            }
        }
        tableView.reloadData()
    }
    
    func setupFavouritesButton() {
        favouritesButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(isFavouritesButtonPressed))
        navigationItem.rightBarButtonItem = favouritesButton
    }
    
    @objc func isFavouritesButtonPressed() {
        if isFavourite {
            isFavourite = false
            navigationItem.title = "Rick and Morty"
            networkRequest(url: charURL)
        } else {
            isFavourite = true
            navigationItem.title = "Избранное"
            makeRequest()
        }
    }
    
    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    func setupTableView() {
        navigationItem.title = "Rick and Morty"
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
            case .failure(_):
                print("error:")
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableView:
            if isFavourite {
                return self.favouriteCharactersData.count
            } else {
                return self.dataResponse?.results.count ?? 0
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        if isFavourite {
            let data = favouriteCharactersData[indexPath.row]
            cell.textLabel?.text = data?.name
            let url = URL(string: data?.image ?? "")
            if let data = try? Data(contentsOf: url!)
            {
                cell.imageView?.image = UIImage(data: data)
            }
        }
        else {
            let data = dataResponse?.results[indexPath.row]
            cell.textLabel?.text = data?.name
            let url = URL(string: data?.image ?? "")
            if let data = try? Data(contentsOf: url!)
            {
                cell.imageView?.image = UIImage(data: data)
            }
        }
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var id = Int()
        var name = String()
        var status =  String()
        var species =  String()
        var gender =  String()
        var image =  String()
        
        if isFavourite {
            let data = favouriteCharactersData[indexPath.row]
            id = data?.id ?? 0
            name = data?.name ?? ""
            status = data?.status ?? ""
            species = data?.species ?? ""
            gender = data?.gender ?? ""
            image = data?.image ?? ""
        } else {
            let data = dataResponse?.results[indexPath.row]
            id = data?.id ?? 0
            name = data?.name ?? ""
            status = data?.status ?? ""
            species = data?.species ?? ""
            gender = data?.gender ?? ""
            image = data?.image ?? ""
        }
        
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
