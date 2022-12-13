import Foundation

class Connection {
    let networkService = NetworkService()
    var dataResponse: DataResponse? = nil
    
    func connect(URL: String) {
        networkService.request(dataURL: URL) { [weak self] (result) in
            switch result {
            case .success(let dataResponse):
                dataResponse.results.map { (characterData) in
                    self?.dataResponse = dataResponse
                }
            case .failure(let error):
                print("error:", error)
            }
        }
    }
}
