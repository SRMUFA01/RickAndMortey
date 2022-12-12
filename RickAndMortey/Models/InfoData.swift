import Foundation

struct DataResponse: Decodable {
    var results: [CharacterData]
}

struct CharacterData: Decodable {
    var name: String
    var status: String
    var species: String
    var gender: String
    var image: String
}
