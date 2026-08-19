import SwiftUI

struct TripsView: View {
    
    @EnvironmentObject private var bookingManager: BookingManager
    
    var body: some View {
        NavigationStack {
            
            Group {
                if bookingManager.bookings.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(
                            alignment: .leading,
                            spacing: 20
                        ) {
                            
                            Text("Your trips")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.horizontal, 20)
                            
                            ForEach(bookingManager.bookings) { booking in
                                NavigationLink {
                                    TripDetailView(
                                        booking: booking
                                    )
                                } label: {
                                    bookingCard(booking)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 20)
                    }
                }
            }
            .navigationTitle("Trips")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Empty State
    
    private var emptyState: some View {
        ContentUnavailableView(
            "No Trips Yet",
            systemImage: "airplane",
            description: Text(
                "Your confirmed reservations will appear here."
            )
        )
    }
    
    // MARK: - Booking Card
    
    private func bookingCard(
        _ booking: Booking
    ) -> some View {
        
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            
            // MARK: Image
            
            Image(booking.property.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 220)
                .frame(maxWidth: .infinity)
                .clipped()
            
            VStack(
                alignment: .leading,
                spacing: 14
            ) {
                
                // MARK: Property
                
                VStack(
                    alignment: .leading,
                    spacing: 5
                ) {
                    
                    Text(booking.property.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text(booking.property.location)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Divider()
                
                // MARK: Dates
                
                HStack {
                    
                    VStack(
                        alignment: .leading,
                        spacing: 4
                    ) {
                        
                        Text("CHECK-IN")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        
                        Text(
                            booking.checkIn.formatted(
                                date: .abbreviated,
                                time: .omitted
                            )
                        )
                        .font(.subheadline)
                        .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    VStack(
                        alignment: .trailing,
                        spacing: 4
                    ) {
                        
                        Text("CHECK-OUT")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        
                        Text(
                            booking.checkOut.formatted(
                                date: .abbreviated,
                                time: .omitted
                            )
                        )
                        .font(.subheadline)
                        .fontWeight(.medium)
                    }
                }
                
                Divider()
                
                // MARK: Guests + Price
                
                HStack {
                    
                    Label(
                        "\(booking.totalGuests) " +
                        "\(booking.totalGuests == 1 ? "guest" : "guests")",
                        systemImage: "person.2"
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("₹\(booking.totalPrice)")
                        .font(.headline)
                }
                
                // MARK: Status
                
                HStack(spacing: 6) {
                    
                    Image(
                        systemName: "checkmark.circle.fill"
                    )
                    
                    Text("Confirmed")
                        .fontWeight(.medium)
                }
                .font(.subheadline)
                .foregroundStyle(.green)
            }
            .padding(16)
        }
        .background(
            RoundedRectangle(
                cornerRadius: 20
            )
            .fill(.background)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20
            )
        )
        .shadow(
            color: .black.opacity(0.08),
            radius: 10,
            y: 4
        )
        .padding(.horizontal, 20)
    }
}
