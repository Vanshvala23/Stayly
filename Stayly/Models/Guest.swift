import Foundation

enum GuestType:String, Codable, Hashable{
    case adult
    case child
}
struct Guest:Identifiable,Codable, Hashable{
    let id:UUID
    var name:String
    let type:GuestType
    init(
    name:String="",
    type:GuestType
    )
    {self.id=UUID()
        self.name=name
        self.type=type}
    
}
