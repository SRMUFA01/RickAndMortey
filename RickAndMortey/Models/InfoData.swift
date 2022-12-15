import Foundation

// MARK: Данные, получаемые из API

struct DataResponse: Decodable {
    var results: [CharacterData]
}

struct CharacterData: Decodable {
    var id: Int
    var name: String
    var status: String
    var species: String
    var gender: String
    var image: String
}
