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
    
    let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
    
    let allCharactersURL = "https://rickandmortyapi.com/api/character/"
    
    var favouritesButton = UIBarButtonItem()
    var isFavourite = false
    var favouritesArray = [""]
    var iArray = [Int()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateFavouritesArray()
        setupFavouritesButton()
        setupSearchBar()
        setupTableView()
        favouriteCharactersRequest()
        allCharactersRequest(url: allCharactersURL)
    }
    
    // MARK: Установка кнопки "Избранное"
    func setupFavouritesButton() {
        favouritesButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(isFavouritesButtonPressed))
        navigationItem.rightBarButtonItem = favouritesButton
    }
    
    // MARK: Действие при нажатии на кнопку "Избранное"
    @objc func isFavouritesButtonPressed() {
        if isFavourite {
            isFavourite = false
            navigationItem.title = "Rick and Morty"
            allCharactersRequest(url: allCharactersURL)
            enableSearchBar()
        } else {
            isFavourite = true
            navigationItem.title = "Избранное"
            favouriteCharactersRequest()
            disableSearchBar()
        }
    }
    
    // MARK: Установка строки поиска
    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    // MARK: Включение отображение строки поиска
    func enableSearchBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController?.searchBar.isHidden = false
    }
    
    // MARK: Выключение отображения строки поиска
    func disableSearchBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.searchController?.searchBar.isHidden = true
        navigationItem.searchController?.searchBar.removeFromSuperview()
    }
    
    // MARK: Установка таблицы
    func setupTableView() {
        navigationItem.title = "Rick and Morty"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect.init(origin: .zero, size: view.frame.size)
    }
    
    // MARK: Обновление массива с ID избранных персонажей
    func updateFavouritesArray() {
        let favouriteObjects = realm.objects(FavouriteCharacters.self)
        if favouriteObjects.count != 0 {
            for i in 1..<(favouriteObjects.count) {
                if favouritesArray.contains(realm.objects(FavouriteCharacters.self)[i].id) { }
                else { favouritesArray.append(realm.objects(FavouriteCharacters.self)[i].id) }
            }
        }
    }
    
    // MARK: Запрос к списку всех персонажей
    func allCharactersRequest(url: String) {
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
    
    // MARK: Запрос к списку избранных персонажей
    func favouriteCharactersRequest() {
        updateFavouritesArray()
        
        for i in 1..<(favouritesArray.count) {
            if iArray.contains(i) { }
            else {
                let favouritesURL = "https://rickandmortyapi.com/api/character/\(favouritesArray[i])"
                
                let request = URLRequest(url: URL(string: favouritesURL)!)
                let addFavourites = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data, let charData = try? JSONDecoder().decode(CharacterData.self, from: data) {
                        self.favouriteCharactersData.append(charData)
                        self.tableView.reloadData()
                    }
                    self.iArray.append(i)
                }
                addFavourites.resume()
            }
        }
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: Определение количества ячеек
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
    
    // MARK: Заполнение таблицы
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
    
    // MARK: Действие при выборе одной из ячеек
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
        coordinator?.showInfo(id: id , name: name , status: status , species: species , gender: gender , image: image )
    }
}

extension MainViewController : UISearchBarDelegate {
    // MARK: Функция поиска
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let dataURL = "https://rickandmortyapi.com/api/character/?name=\(searchText)"
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.allCharactersRequest(url: dataURL)
        })
    }
}
