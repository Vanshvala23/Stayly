import SwiftUI

struct TripDetailView: View {
    
    let booking: Booking
    
    @EnvironmentObject private var bookingManager: BookingManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingCancelConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 24
            ) {
                
                // MARK: - Property Image
                
                propertyImage
                
                // MARK: - Property Information
                
                propertyInformation
                
                // MARK: - Reservation Status
                
                reservationStatus
                
                // MARK: - Trip Dates
                
                tripDates
                
                // MARK: - Guests
                
                guestsSection
                
                // MARK: - Price
                
                priceSection
                
                // MARK: - Cancel Reservation
                
                cancelButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 32)
        }
        .scrollIndicators(.hidden)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Trip Details")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            "Cancel Reservation?",
            isPresented: $showingCancelConfirmation,
            titleVisibility: .visible
        ) {
            
            Button(
                "Cancel Reservation",
                role: .destructive
            ) {
                bookingManager.cancelBooking(booking)
                dismiss()
            }
            
            Button(
                "Keep Reservation",
                role: .cancel
            ) {
                // Nothing to do.
            }
            
        } message: {
            Text(
                "Are you sure you want to cancel your stay at \(booking.property.title)?"
            )
        }
    }
    
    // MARK: - Property Image
    
    // MARK: - Property Image

    private var propertyImage: some View {
        GeometryReader { geometry in
            Image(booking.property.imageName)
                .resizable()
                .scaledToFill()
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.width * 0.68
                )
                .clipped()
        }
        .aspectRatio(1 / 0.68, contentMode: .fit)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
        )
    }
    
    // MARK: - Property Information
    
    private var propertyInformation: some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            
            Text(booking.property.title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
            
            Text(booking.property.location)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.leading)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
            
            HStack(
                alignment: .center,
                spacing: 6
            ) {
                
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                
                Text(
                    String(
                        format: "%.2f",
                        booking.property.rating
                    )
                )
                .fontWeight(.semibold)
                
                Text("·")
                    .foregroundStyle(.secondary)
                
                Text(
                    "\(booking.property.reviewCount) reviews"
                )
                .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            .fixedSize(
                horizontal: false,
                vertical: true
            )
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }
    
    // MARK: - Reservation Status
    
    private var reservationStatus: some View {
        HStack(
            alignment: .center,
            spacing: 12
        ) {
            
            Image(
                systemName: "checkmark.circle.fill"
            )
            .font(.title3)
            .foregroundStyle(.green)
            
            VStack(
                alignment: .leading,
                spacing: 3
            ) {
                
                Text("Reservation confirmed")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("Your stay is booked")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(
            RoundedRectangle(
                cornerRadius: 16
            )
            .fill(.green.opacity(0.10))
        )
    }
    
    // MARK: - Trip Dates
    
    private var tripDates: some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            
            Text("Your trip")
                .font(.title3)
                .fontWeight(.semibold)
            
            ViewThatFits(
                in: .horizontal
            ) {
                
                // MARK: Wide Layout
                
                HStack(
                    alignment: .center,
                    spacing: 12
                ) {
                    
                    dateCard(
                        title: "CHECK-IN",
                        date: booking.checkIn,
                        alignment: .leading
                    )
                    
                    Image(systemName: "arrow.right")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    
                    dateCard(
                        title: "CHECK-OUT",
                        date: booking.checkOut,
                        alignment: .trailing
                    )
                }
                
                // MARK: Compact Layout
                
                VStack(spacing: 10) {
                    
                    dateCard(
                        title: "CHECK-IN",
                        date: booking.checkIn,
                        alignment: .leading
                    )
                    
                    HStack {
                        Spacer()
                        
                        Image(
                            systemName: "arrow.down"
                        )
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        
                        Spacer()
                    }
                    
                    dateCard(
                        title: "CHECK-OUT",
                        date: booking.checkOut,
                        alignment: .leading
                    )
                }
            }
        }
    }
    
    // MARK: - Date Card
    
    private func dateCard(
        title: String,
        date: Date,
        alignment: HorizontalAlignment
    ) -> some View {
        
        VStack(
            alignment: alignment,
            spacing: 6
        ) {
            
            Text(title)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
            
            Text(
                date.formatted(
                    date: .abbreviated,
                    time: .omitted
                )
            )
            .font(.subheadline)
            .fontWeight(.semibold)
            .multilineTextAlignment(
                alignment == .leading
                ? .leading
                : .trailing
            )
            .fixedSize(
                horizontal: false,
                vertical: true
            )
        }
        .frame(
            maxWidth: .infinity,
            alignment: Alignment(
                horizontal: alignment,
                vertical: .center
            )
        )
        .padding(
            .vertical,
            14
        )
        .padding(
            .horizontal,
            12
        )
        .background(
            RoundedRectangle(
                cornerRadius: 14
            )
            .fill(.quaternary.opacity(0.5))
        )
    }
    
    // MARK: - Guests Section
    
    private var guestsSection: some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            
            Text("Guests")
                .font(.title3)
                .fontWeight(.semibold)
            
            HStack(
                alignment: .center,
                spacing: 14
            ) {
                
                Image(systemName: "person.2.fill")
                    .font(.title3)
                    .foregroundStyle(.tint)
                    .frame(
                        width: 40,
                        height: 40
                    )
                    .background(
                        Circle()
                            .fill(.tint.opacity(0.12))
                    )
                
                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    
                    Text(
                        "\(booking.totalGuests) " +
                        "\(booking.totalGuests == 1 ? "guest" : "guests")"
                    )
                    .fontWeight(.semibold)
                    
                    guestDescription
                }
                
                Spacer(minLength: 0)
            }
            .padding(16)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .background(
                RoundedRectangle(
                    cornerRadius: 16
                )
                .fill(.background)
            )
        }
    }
    
    // MARK: - Guest Description
    
    private var guestDescription: some View {
        Group {
            
            if booking.children > 0 {
                
                Text(
                    "\(booking.adults) " +
                    "\(booking.adults == 1 ? "adult" : "adults")" +
                    " · " +
                    "\(booking.children) " +
                    "\(booking.children == 1 ? "child" : "children")"
                )
                
            } else {
                
                Text(
                    "\(booking.adults) " +
                    "\(booking.adults == 1 ? "adult" : "adults")"
                )
            }
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .fixedSize(
            horizontal: false,
            vertical: true
        )
    }
    
    // MARK: - Price Section
    
    private var priceSection: some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            
            Text("Price details")
                .font(.title3)
                .fontWeight(.semibold)
            
            VStack(spacing: 14) {
                
                HStack(
                    alignment: .center,
                    spacing: 12
                ) {
                    
                    Text(
                        "₹\(booking.property.price) × " +
                        "\(booking.numberOfNights) " +
                        "\(booking.numberOfNights == 1 ? "night" : "nights")"
                    )
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
                    
                    Spacer(minLength: 12)
                    
                    Text(
                        "₹\(booking.property.price * booking.numberOfNights)"
                    )
                    .fontWeight(.medium)
                }
                
                Divider()
                
                HStack(
                    alignment: .center,
                    spacing: 12
                ) {
                    
                    Text("Total paid")
                        .fontWeight(.semibold)
                    
                    Spacer(minLength: 12)
                    
                    Text("₹\(booking.totalPrice)")
                        .font(.title3)
                        .fontWeight(.bold)
                }
            }
            .font(.subheadline)
            .padding(18)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .background(
                RoundedRectangle(
                    cornerRadius: 16
                )
                .fill(.background)
            )
        }
    }
    
    // MARK: - Cancel Button
    
    private var cancelButton: some View {
        Button(role: .destructive) {
            showingCancelConfirmation = true
        } label: {
            
            HStack(spacing: 8) {
                
                Image(
                    systemName: "xmark.circle"
                )
                
                Text("Cancel Reservation")
                    .fontWeight(.semibold)
            }
            .frame(
                maxWidth: .infinity
            )
            .padding(.vertical, 16)
        }
        .buttonStyle(.bordered)
        .tint(.red)
        .padding(.top, 4)
    }
}
