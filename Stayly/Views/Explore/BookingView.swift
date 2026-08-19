import SwiftUI

struct BookingView: View {
    
    let property: Property
    
    @EnvironmentObject private var bookingManager: BookingManager
    
    @State private var confirmedBooking: Booking?
    
    @State private var checkIn = Calendar.current.date(
        byAdding: .day,
        value: 1,
        to: Date()
    ) ?? Date()
    
    @State private var checkOut = Calendar.current.date(
        byAdding: .day,
        value: 2,
        to: Date()
    ) ?? Date()
    
    @State private var adults = 1
    @State private var children = 0
    
    // MARK: - Guests
    
    private var totalGuests: Int {
        adults + children
    }
    
    // MARK: - Nights
    
    private var numberOfNights: Int {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents(
            [.day],
            from: checkIn,
            to: checkOut
        )
        
        return max(
            1,
            components.day ?? 1
        )
    }
    
    private var nightText: String {
        numberOfNights == 1 ? "night" : "nights"
    }
    
    // MARK: - Price
    
    private var subtotal: Int {
        property.price * numberOfNights
    }
    
    private var cleaningFee: Int {
        500
    }
    
    private var serviceFee: Int {
        Int(
            Double(subtotal) * 0.10
        )
    }
    
    private var totalPrice: Int {
        subtotal + cleaningFee + serviceFee
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(
                    alignment: .leading,
                    spacing: 24
                ) {
                    
                    // MARK: Property
                    
                    propertySection
                    
                    Divider()
                    
                    // MARK: Dates
                    
                    datesSection
                    
                    // MARK: Guests
                    
                    guestsSection
                    
                    // MARK: Price Details
                    
                    priceSection
                }
                .padding(20)
            }
            .navigationTitle("Reserve")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                confirmButton
            }
            .navigationDestination(
                item: $confirmedBooking
            ) { booking in
                BookingConfirmationView(
                    booking: booking
                )
            }
        }
    }
    
    // MARK: - Property Section
    
    private var propertySection: some View {
        HStack(spacing: 14) {
            
            Image(property.imageName)
                .resizable()
                .scaledToFill()
                .frame(
                    width: 100,
                    height: 90
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 14
                    )
                )
            
            VStack(
                alignment: .leading,
                spacing: 6
            ) {
                
                Text(property.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(property.location)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 4) {
                    
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    
                    Text(
                        String(
                            format: "%.2f",
                            property.rating
                        )
                    )
                    .font(.subheadline)
                }
            }
            
            Spacer()
        }
    }
    
    // MARK: - Dates Section
    
    private var datesSection: some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            
            Text("Your trip")
                .font(.title3)
                .fontWeight(.semibold)
            
            VStack(spacing: 0) {
                
                DatePicker(
                    "Check-in",
                    selection: $checkIn,
                    in: Date()...,
                    displayedComponents: .date
                )
                .padding(.vertical, 8)
                .onChange(
                    of: checkIn
                ) { _, newCheckIn in
                    
                    if checkOut <= newCheckIn {
                        checkOut = Calendar.current.date(
                            byAdding: .day,
                            value: 1,
                            to: newCheckIn
                        ) ?? newCheckIn
                    }
                }
                
                Divider()
                
                DatePicker(
                    "Check-out",
                    selection: $checkOut,
                    in: minimumCheckOutDate...,
                    displayedComponents: .date
                )
                .padding(.vertical, 8)
            }
            .padding(.horizontal)
            .background(
                RoundedRectangle(
                    cornerRadius: 16
                )
                .fill(
                    .quaternary.opacity(0.5)
                )
            )
        }
    }
    
    // MARK: - Minimum Check-out Date
    
    private var minimumCheckOutDate: Date {
        Calendar.current.date(
            byAdding: .day,
            value: 1,
            to: checkIn
        ) ?? checkIn
    }
    
    // MARK: - Guests Section
    
    private var guestsSection: some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            
            HStack {
                
                Text("Guests")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(totalGuests)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                
                Text(
                    totalGuests == 1
                    ? "guest"
                    : "guests"
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            
            VStack(spacing: 0) {
                
                guestRow(
                    title: "Adults",
                    subtitle: "Age 13+",
                    value: $adults,
                    minimum: 1
                )
                
                Divider()
                
                guestRow(
                    title: "Children",
                    subtitle: "Age 2–12",
                    value: $children,
                    minimum: 0
                )
            }
            .padding(.horizontal)
            .background(
                RoundedRectangle(
                    cornerRadius: 16
                )
                .fill(
                    .quaternary.opacity(0.5)
                )
            )
        }
    }
    
    // MARK: - Guest Row
    
    private func guestRow(
        title: String,
        subtitle: String,
        value: Binding<Int>,
        minimum: Int
    ) -> some View {
        
        HStack {
            
            VStack(
                alignment: .leading,
                spacing: 3
            ) {
                
                Text(title)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                
                // MARK: Minus
                
                Button {
                    
                    guard value.wrappedValue > minimum else {
                        return
                    }
                    
                    value.wrappedValue -= 1
                    
                } label: {
                    
                    Image(systemName: "minus")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(
                            width: 32,
                            height: 32
                        )
                        .background(
                            Circle()
                                .stroke(.secondary)
                        )
                }
                .buttonStyle(.plain)
                
                // MARK: Value
                
                Text(
                    "\(value.wrappedValue)"
                )
                .fontWeight(.semibold)
                .frame(minWidth: 20)
                
                // MARK: Plus
                
                Button {
                    
                    value.wrappedValue += 1
                    
                } label: {
                    
                    Image(systemName: "plus")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(
                            width: 32,
                            height: 32
                        )
                        .background(
                            Circle()
                                .stroke(.secondary)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 14)
    }
    
    // MARK: - Price Section
    
    private var priceSection: some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            
            Text("Price details")
                .font(.title3)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                
                priceRow(
                    title: "₹\(property.price) × \(numberOfNights) \(nightText)",
                    amount: subtotal
                )
                
                priceRow(
                    title: "Cleaning fee",
                    amount: cleaningFee
                )
                
                priceRow(
                    title: "Service fee",
                    amount: serviceFee
                )
                
                Divider()
                
                HStack {
                    
                    Text("Total")
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text("₹\(totalPrice)")
                        .fontWeight(.bold)
                }
            }
        }
    }
    
    // MARK: - Price Row
    
    private func priceRow(
        title: String,
        amount: Int
    ) -> some View {
        
        HStack {
            
            Text(title)
            
            Spacer()
            
            Text("₹\(amount)")
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }
    
    // MARK: - Confirm Button
    
    private var confirmButton: some View {
        Button {
            
            let booking = bookingManager.addBooking(
                property: property,
                checkIn: checkIn,
                checkOut: checkOut,
                adults: adults,
                children: children,
                totalPrice: totalPrice
            )
            
            confirmedBooking = booking
            
        } label: {
            
            Text(
                "Confirm Reservation · ₹\(totalPrice)"
            )
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(.tint)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 16
                )
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.regularMaterial)
        .overlay(alignment: .top) {
            Divider()
        }
    }
}
