import Foundation

struct Amenity: Codable,Hashable {
    let icon: String
    let name: String
}

struct Property: Identifiable, Codable,Hashable {
    
    let id: UUID
    let title: String
    let location: String
    let price: Int
    let rating: Double
    let imageName: String
    let category: String
    let description: String
    let hostName: String
    let reviewCount: Int
    let guests: Int
    let bedrooms: Int
    let beds: Int
    let bathrooms: Int
    let amenities: [Amenity]
    
    init(
        id: UUID = UUID(),
        title: String,
        location: String,
        price: Int,
        rating: Double,
        imageName: String,
        category: String,
        description: String,
        hostName: String,
        reviewCount: Int,
        guests: Int,
        bedrooms: Int,
        beds: Int,
        bathrooms: Int,
        amenities: [Amenity]
    ) {
        self.id = id
        self.title = title
        self.location = location
        self.price = price
        self.rating = rating
        self.imageName = imageName
        self.category = category
        self.description = description
        self.hostName = hostName
        self.reviewCount = reviewCount
        self.guests = guests
        self.bedrooms = bedrooms
        self.beds = beds
        self.bathrooms = bathrooms
        self.amenities = amenities
    }
}
