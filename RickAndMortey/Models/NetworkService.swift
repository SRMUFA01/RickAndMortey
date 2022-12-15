import Foundation

// MARK: Запрос к списку всех персонажей

class NetworkService {
    func request(dataURL: String, completion: @escaping (Result<DataResponse, Error>) -> Void) {
        guard let url = URL(string: dataURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                do {
                    let characterData = try JSONDecoder().decode(DataResponse.self, from: data)
                    completion(.success(characterData))
                } catch let jsonError {
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
}
