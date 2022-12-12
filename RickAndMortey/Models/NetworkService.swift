import Foundation

class NetworkService {
    func request(completion: @escaping (Result<DataResponse, Error>) -> Void) {
        let dataURL = "https://rickandmortyapi.com/api/character/"
        guard let url = URL(string: dataURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("error")
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                do {
                    let characterData = try JSONDecoder().decode(DataResponse.self, from: data)
                    completion(.success(characterData))
                } catch let jsonError {
                    print("Ошибка:", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
}
