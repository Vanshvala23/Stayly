import SwiftUI

struct BookingView: View {
    
    let property: Property
    
    @EnvironmentObject private var tabNavigationManager: TabNavigationManager
    @EnvironmentObject private var bookingManager: BookingManager
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Navigation
    
    @State private var showingGuestDetails = false
    
    // MARK: - Booking State
    
    @State private var guests: [Guest] = []
    
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
        let components = Calendar.current.dateComponents(
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
        Int(Double(subtotal) * 0.10)
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
                    propertySection
                    
                    Divider()
                    
                    datesSection
                    
                    guestsSection
                    
                    priceSection
                }
                .padding(20)
            }
            .navigationTitle("Reserve")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                continueButton
            }
            .navigationDestination(
                isPresented: $showingGuestDetails
            ) {
                GuestDetailsView(
                    adults: adults,
                    children: children
                ) { enteredGuests in
                    
                    print("GUESTS RECEIVED:", enteredGuests)
                    
                    // Save the guests.
                    guests = enteredGuests
                    
                    print("SAVED GUESTS:", guests)
                    
                    // Create the booking immediately.
                    createBooking(
                        with: enteredGuests
                    )
                }
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
                .onChange(of: checkIn) { _, newCheckIn in
                    
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
                
                Button {
                    if value.wrappedValue > minimum {
                        value.wrappedValue -= 1
                    }
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
                
                Text("\(value.wrappedValue)")
                    .fontWeight(.semibold)
                    .frame(minWidth: 20)
                
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
    
    // MARK: - Continue Button
    
    private var continueButton: some View {
        Button {
            
            print("OPENING GUEST DETAILS")
            
            showingGuestDetails = true
            
        } label: {
            
            Text("Continue · ₹\(totalPrice)")
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
    
    // MARK: - Create Booking
    
    private func createBooking(
        with guests: [Guest]
    ) {
        
        print("CREATING BOOKING")
        print("GUESTS:", guests)
        print("ADULTS:", adults)
        print("CHILDREN:", children)
        print("CHECK-IN:", checkIn)
        print("CHECK-OUT:", checkOut)
        print("NIGHTS:", numberOfNights)
        print("TOTAL PRICE:", totalPrice)
        
        // Save booking.
        bookingManager.addBooking(
            property: property,
            checkIn: checkIn,
            checkOut: checkOut,
            adults: adults,
            children: children,
            guests: guests,
            totalPrice: totalPrice
        )
        
        print("BOOKING SAVED")
        
        // Close BookingView.
        dismiss()
        
        // Switch to Trips.
        tabNavigationManager.goToTrips()
    }
}
