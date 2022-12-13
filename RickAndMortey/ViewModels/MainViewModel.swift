import Foundation

class MainViewModel {
    var newid = Dynamic(Int())
    
    func setID(id: Int) {
        newid.value = id
    }
}
