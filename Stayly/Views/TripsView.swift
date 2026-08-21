import SwiftUI

struct TripsView: View {
    
    @EnvironmentObject private var bookingManager: BookingManager
    
    // MARK: - Booking Groups
    
    private var upcomingBookings: [Booking] {
        bookingManager.bookings
            .filter { $0.status == .upcoming }
            .sorted { $0.checkIn < $1.checkIn }
    }
    
    private var completedBookings: [Booking] {
        bookingManager.bookings
            .filter { $0.status == .completed }
            .sorted { $0.checkOut > $1.checkOut }
    }
    
    private var cancelledBookings: [Booking] {
        bookingManager.bookings
            .filter { $0.status == .cancelled }
            .sorted { $0.bookingDate > $1.bookingDate }
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                
                VStack(
                    alignment: .leading,
                    spacing: 30
                ) {
                    
                    // MARK: Header
                    
                    header
                    
                    if bookingManager.bookings.isEmpty {
                        emptyState
                    } else {
                        
                        // MARK: Upcoming
                        
                        if !upcomingBookings.isEmpty {
                            bookingSection(
                                title: "Upcoming",
                                subtitle: "Your next stays",
                                icon: "calendar",
                                bookings: upcomingBookings
                            )
                        }
                        
                        // MARK: Completed
                        
                        if !completedBookings.isEmpty {
                            bookingSection(
                                title: "Completed",
                                subtitle: "Places you've stayed",
                                icon: "checkmark.seal",
                                bookings: completedBookings
                            )
                        }
                        
                        // MARK: Cancelled
                        
                        if !cancelledBookings.isEmpty {
                            bookingSection(
                                title: "Cancelled",
                                subtitle: "Cancelled reservations",
                                icon: "xmark.circle",
                                bookings: cancelledBookings
                            )
                        }
                    }
                }
                .padding(.vertical, 20)
            }
            .scrollIndicators(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Trips")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Header
    
    private var header: some View {
        VStack(
            alignment: .leading,
            spacing: 6
        ) {
            
            Text("Your trips")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(
                bookingManager.bookings.isEmpty
                ? "Your stays will appear here."
                : "\(bookingManager.bookings.count) " +
                  "\(bookingManager.bookings.count == 1 ? "reservation" : "reservations")"
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Booking Section
    
    @ViewBuilder
    private func bookingSection(
        title: String,
        subtitle: String,
        icon: String,
        bookings: [Booking]
    ) -> some View {
        
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            
            sectionHeader(
                title: title,
                subtitle: subtitle,
                icon: icon,
                count: bookings.count
            )
            
            VStack(spacing: 16) {
                
                ForEach(bookings) { booking in
                    
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
        }
    }
    
    // MARK: - Section Header
    
    private func sectionHeader(
        title: String,
        subtitle: String,
        icon: String,
        count: Int
    ) -> some View {
        
        HStack(
            alignment: .center,
            spacing: 12
        ) {
            
            Image(systemName: icon)
                .font(.headline)
                .foregroundStyle(.tint)
                .frame(
                    width: 38,
                    height: 38
                )
                .background(
                    Circle()
                        .fill(.tint.opacity(0.12))
                )
            
            VStack(
                alignment: .leading,
                spacing: 2
            ) {
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("\(count)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(.quaternary)
                )
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Empty State
    
    private var emptyState: some View {
        
        ContentUnavailableView {
            Label(
                "No Trips Yet",
                systemImage: "airplane"
            )
        } description: {
            Text(
                "When you book a stay, your reservations will appear here."
            )
        }
        .frame(
            maxWidth: .infinity
        )
        .padding(.top, 70)
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
            
            ZStack(
                alignment: .topTrailing
            ) {
                
                Image(booking.property.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 220)
                    .frame(maxWidth: .infinity)
                    .clipped()
                
                statusBadge(
                    for: booking.status
                )
                .padding(12)
            }
            
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
                        .font(.caption)
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
            }
            .padding(16)
        }
        .background(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
            .fill(.background)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
        )
        .shadow(
            color: .black.opacity(0.07),
            radius: 12,
            y: 5
        )
        .padding(.horizontal, 20)
    }
    
    // MARK: - Status Badge
    
    private func statusBadge(
        for status: BookingStatus
    ) -> some View {
        
        HStack(spacing: 5) {
            
            Image(
                systemName: statusIcon(
                    for: status
                )
            )
            
            Text(
                statusTitle(
                    for: status
                )
            )
            .fontWeight(.semibold)
        }
        .font(.caption)
        .foregroundStyle(.primary)
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(
            Capsule()
                .fill(.regularMaterial)
        )
    }
    
    // MARK: - Status Icon
    
    private func statusIcon(
        for status: BookingStatus
    ) -> String {
        
        switch status {
        case .upcoming:
            return "checkmark.circle.fill"
            
        case .completed:
            return "checkmark.seal.fill"
            
        case .cancelled:
            return "xmark.circle.fill"
        }
    }
    
    // MARK: - Status Title
    
    private func statusTitle(
        for status: BookingStatus
    ) -> String {
        
        switch status {
        case .upcoming:
            return "Confirmed"
            
        case .completed:
            return "Completed"
            
        case .cancelled:
            return "Cancelled"
        }
    }
}
