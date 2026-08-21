import Foundation
import SwiftUI
import Combine

@MainActor
final class BookingManager: ObservableObject {
    
    @Published private(set) var bookings: [Booking] = []
    
    private let storageKey = "stayly_bookings"
    
    // MARK: - Init
    
    init() {
        loadBookings()
        updateBookingStatuses()
    }
    
    // MARK: - Add Booking
    
    @discardableResult
    func addBooking(
        property: Property,
        checkIn: Date,
        checkOut: Date,
        adults: Int,
        children: Int,
        guests:[Guest],
        totalPrice: Int
    ) -> Booking {
        
        let booking = Booking(
            property: property,
            checkIn: checkIn,
            checkOut: checkOut,
            adults: adults,
            children: children,
            guests:guests,
            totalPrice: totalPrice
        )
        
        bookings.append(booking)
        saveBookings()
        
        return booking
    }
    
    // MARK: - Cancel Booking
    
    func cancelBooking(_ booking: Booking) {
        
        guard let index = bookings.firstIndex(
            where: { $0.id == booking.id }
        ) else {
            return
        }
        
        bookings[index].status = .cancelled
        
        saveBookings()
    }
    
    // MARK: - Delete cancelled Booking
    
    func deleteBooking(_ booking:Booking){
        bookings.removeAll{ $0.id == booking.id}
        saveBookings()
    }
    
    // MARK: - Update Booking Status
    
    func updateBookingStatuses() {
        
        let now = Date()
        
        for index in bookings.indices {
            
            if bookings[index].status == .upcoming &&
                bookings[index].checkOut <= now {
                
                bookings[index].status = .completed
            }
        }
        
        saveBookings()
    }
    
    // MARK: - Save Bookings
    
    private func saveBookings() {
        
        do {
            let data = try JSONEncoder().encode(bookings)
            
            UserDefaults.standard.set(
                data,
                forKey: storageKey
            )
            
        } catch {
            print(
                "Failed to save bookings: \(error)"
            )
        }
    }
    
    // MARK: - Load Bookings
    
    private func loadBookings() {
        
        guard let data = UserDefaults.standard.data(
            forKey: storageKey
        ) else {
            return
        }
        
        do {
            bookings = try JSONDecoder().decode(
                [Booking].self,
                from: data
            )
            
        } catch {
            print(
                "Failed to load bookings: \(error)"
            )
        }
    }
}
