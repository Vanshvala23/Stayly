import SwiftUI

struct BookingConfirmationView: View {
    
    let booking: Booking
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            
            ScrollView {
                VStack(spacing: 28) {
                    
                    // MARK: - Success Icon
                    
                    ZStack {
                        Circle()
                            .fill(.green.opacity(0.12))
                            .frame(
                                width: 100,
                                height: 100
                            )
                        
                        Image(
                            systemName: "checkmark"
                        )
                        .font(.system(
                            size: 42,
                            weight: .bold
                        ))
                        .foregroundStyle(.green)
                    }
                    .padding(.top, 30)
                    
                    // MARK: - Title
                    
                    VStack(spacing: 8) {
                        
                        Text("Reservation Confirmed!")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(
                            "Your stay is officially booked."
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                    
                    // MARK: - Property Card
                    
                    VStack(
                        alignment: .leading,
                        spacing: 0
                    ) {
                        
                        Image(booking.property.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 190)
                            .frame(maxWidth: .infinity)
                            .clipped()
                        
                        VStack(
                            alignment: .leading,
                            spacing: 8
                        ) {
                            
                            Text(booking.property.title)
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text(booking.property.location)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
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
                    
                    // MARK: - Trip Information
                    
                    VStack(
                        alignment: .leading,
                        spacing: 18
                    ) {
                        
                        Text("Trip details")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        confirmationRow(
                            icon: "calendar",
                            title: "Check-in",
                            value: booking.checkIn.formatted(
                                date: .abbreviated,
                                time: .omitted
                            )
                        )
                        
                        confirmationRow(
                            icon: "calendar",
                            title: "Check-out",
                            value: booking.checkOut.formatted(
                                date: .abbreviated,
                                time: .omitted
                            )
                        )
                        
                        confirmationRow(
                            icon: "moon",
                            title: "Duration",
                            value: "\(booking.numberOfNights) \(booking.numberOfNights == 1 ? "night" : "nights")"
                        )
                        
                        confirmationRow(
                            icon: "person.2",
                            title: "Guests",
                            value: "\(booking.totalGuests)"
                        )
                        
                        confirmationRow(
                            icon: "indianrupeesign",
                            title: "Total",
                            value: "₹\(booking.totalPrice)"
                        )
                    }
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding(20)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                        .fill(.quaternary.opacity(0.5))
                    )
                    
                    // MARK: - Confirmation Message
                    
                    HStack(
                        alignment: .top,
                        spacing: 12
                    ) {
                        
                        Image(
                            systemName: "info.circle.fill"
                        )
                        .foregroundStyle(.tint)
                        
                        Text(
                            "Your reservation has been saved to your trips. You can view or cancel it anytime from the Trips tab."
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                }
                .padding(20)
            }
            
            // MARK: - Bottom Button
            
            Button {
                dismiss()
            } label: {
                Text("Done")
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
        .navigationTitle("Confirmed")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Confirmation Row
    
    private func confirmationRow(
        icon: String,
        title: String,
        value: String
    ) -> some View {
        
        HStack(spacing: 14) {
            
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(.tint)
                .frame(
                    width: 24
                )
            
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
}
