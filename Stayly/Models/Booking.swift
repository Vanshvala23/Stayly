import Foundation

enum BookingStatus: String, Codable, Hashable {
    case upcoming
    case completed
    case cancelled
}

struct Booking: Identifiable, Codable, Hashable {
    
    let id: UUID
    let property: Property
    let checkIn: Date
    let checkOut: Date
    let adults: Int
    let children: Int
    let guests:[Guest]
    let totalPrice: Int
    let bookingDate: Date
    
    var status: BookingStatus
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case id
        case property
        case checkIn
        case checkOut
        case adults
        case children
        case guests
        case totalPrice
        case bookingDate
        case status
    }
    
    // MARK: - Create Booking
    
    init(
        property: Property,
        checkIn: Date,
        checkOut: Date,
        adults: Int,
        children: Int,
        guests:[Guest],
        totalPrice: Int
    ) {
        self.id = UUID()
        self.property = property
        self.checkIn = checkIn
        self.checkOut = checkOut
        self.adults = adults
        self.children = children
        self.guests = guests
        self.totalPrice = totalPrice
        self.bookingDate = Date()
        self.status = .upcoming
    }
    
    // MARK: - Decode
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )
        
        id = try container.decode(
            UUID.self,
            forKey: .id
        )
        
        property = try container.decode(
            Property.self,
            forKey: .property
        )
        
        checkIn = try container.decode(
            Date.self,
            forKey: .checkIn
        )
        
        checkOut = try container.decode(
            Date.self,
            forKey: .checkOut
        )
        
        adults = try container.decode(
            Int.self,
            forKey: .adults
        )
        
        children = try container.decode(
            Int.self,
            forKey: .children
        )
        
        guests=try container.decodeIfPresent([Guest].self, forKey: .guests) ?? []
        
        totalPrice = try container.decode(
            Int.self,
            forKey: .totalPrice
        )
        
        bookingDate = try container.decode(
            Date.self,
            forKey: .bookingDate
        )
        
        // Backward compatibility with existing saved bookings
        status = try container.decodeIfPresent(
            BookingStatus.self,
            forKey: .status
        ) ?? .upcoming
    }
    
    // MARK: - Guests
    
    var totalGuests: Int {
        adults + children
    }
    
    // MARK: - Nights
    
    var numberOfNights: Int {
        
        let calendar = Calendar.current
        
        return max(
            1,
            calendar.dateComponents(
                [.day],
                from: checkIn,
                to: checkOut
            ).day ?? 1
        )
    }
}
