import Foundation

class MainViewModel {
    var id = Dynamic(Int())
    var name = Dynamic(String())
    var status = Dynamic(String())
    var species = Dynamic(String())
    var gender = Dynamic(String())
    var image = Dynamic(String())
    
    func setID(id: Int, name: String, status: String, species: String, gender: String, image: String) {
        self.id.value = id
        self.name.value = name
        self.status.value = status
        self.species.value = species
        self.gender.value = gender
        self.image.value = image
    }
}
