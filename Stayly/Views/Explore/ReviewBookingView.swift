import SwiftUI

struct ReviewBookingView: View {

    let property: Property
    let checkIn: Date
    let checkOut: Date
    let adults: Int
    let children: Int
    let guests: [Guest]
    let numberOfNights: Int
    let subtotal: Int
    let cleaningFee: Int
    let serviceFee: Int
    let totalPrice: Int

    let onConfirm: () -> Void

    @Environment(\.dismiss) private var dismiss

    private var totalGuests: Int {
        adults + children
    }

    private var nightText: String {
        numberOfNights == 1 ? "night" : "nights"
    }

    var body: some View {

        ScrollView {

            VStack(
                alignment: .leading,
                spacing: 24
            ) {

                // MARK: - Header

                VStack(
                    alignment: .leading,
                    spacing: 6
                ) {

                    Text("Review your stay")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(
                        "Please check your trip details before confirming."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }

                // MARK: - Property

                propertyCard

                // MARK: - Trip Details

                tripDetailsSection

                // MARK: - Guest Details

                guestDetailsSection

                // MARK: - Price Details

                priceDetailsSection

                // MARK: - Information

                HStack(
                    alignment: .top,
                    spacing: 12
                ) {

                    Image(
                        systemName: "info.circle.fill"
                    )
                    .foregroundStyle(.tint)

                    Text(
                        "Your booking will be saved to Trips after you confirm."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .padding(16)
                .background(
                    RoundedRectangle(
                        cornerRadius: 16
                    )
                    .fill(
                        .quaternary.opacity(0.5)
                    )
                )
            }
            .padding(20)
        }
        .navigationTitle("Review Booking")
        .navigationBarTitleDisplayMode(.inline)

        // MARK: - Confirm Button

        .safeAreaInset(edge: .bottom) {

            Button {

                onConfirm()

            } label: {

                Text("Confirm Booking · ₹\(totalPrice)")
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

    // MARK: - Property Card

    private var propertyCard: some View {

        VStack(
            alignment: .leading,
            spacing: 0
        ) {

            Image(property.imageName)
                .resizable()
                .scaledToFill()
                .frame(
                    height: 190
                )
                .frame(
                    maxWidth: .infinity
                )
                .clipped()

            VStack(
                alignment: .leading,
                spacing: 6
            ) {

                Text(property.title)
                    .font(.title3)
                    .fontWeight(.semibold)

                Text(property.location)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 5) {

                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)

                    Text(
                        String(
                            format: "%.2f",
                            property.rating
                        )
                    )
                    .font(.subheadline)
                    .fontWeight(.medium)
                }
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
    }

    // MARK: - Trip Details

    private var tripDetailsSection: some View {

        VStack(
            alignment: .leading,
            spacing: 18
        ) {

            Text("Trip details")
                .font(.title3)
                .fontWeight(.semibold)

            reviewRow(
                icon: "calendar",
                title: "Check-in",
                value: checkIn.formatted(
                    date: .abbreviated,
                    time: .omitted
                )
            )

            reviewRow(
                icon: "calendar",
                title: "Check-out",
                value: checkOut.formatted(
                    date: .abbreviated,
                    time: .omitted
                )
            )

            reviewRow(
                icon: "moon",
                title: "Duration",
                value: "\(numberOfNights) \(nightText)"
            )

            reviewRow(
                icon: "person.2",
                title: "Guests",
                value: guestSummary
            )
        }
        .padding(20)
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(
            RoundedRectangle(
                cornerRadius: 20
            )
            .fill(
                .quaternary.opacity(0.5)
            )
        )
    }

    // MARK: - Guest Details

    private var guestDetailsSection: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            Text("Guest details")
                .font(.title3)
                .fontWeight(.semibold)

            ForEach(guests) { guest in

                HStack(spacing: 12) {

                    Image(
                        systemName:
                            guest.type == .adult
                            ? "person.fill"
                            : "figure.and.child.holdinghands"
                    )
                    .foregroundStyle(.tint)
                    .frame(width: 24)

                    VStack(
                        alignment: .leading,
                        spacing: 2
                    ) {

                        Text(guest.name)
                            .font(.subheadline)
                            .fontWeight(.medium)

                        Text(
                            guest.type == .adult
                            ? "Adult"
                            : "Child"
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }

                    Spacer()
                }
            }
        }
        .padding(20)
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(
            RoundedRectangle(
                cornerRadius: 20
            )
            .fill(
                .quaternary.opacity(0.5)
            )
        )
    }

    // MARK: - Price Details

    private var priceDetailsSection: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            Text("Price details")
                .font(.title3)
                .fontWeight(.semibold)

            priceRow(
                title:
                    "₹\(property.price) × \(numberOfNights) \(nightText)",
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
        .padding(20)
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(
            RoundedRectangle(
                cornerRadius: 20
            )
            .fill(
                .quaternary.opacity(0.5)
            )
        )
    }

    // MARK: - Guest Summary

    private var guestSummary: String {

        var parts: [String] = []

        if adults > 0 {
            parts.append(
                "\(adults) \(adults == 1 ? "adult" : "adults")"
            )
        }

        if children > 0 {
            parts.append(
                "\(children) \(children == 1 ? "child" : "children")"
            )
        }

        return parts.joined(separator: ", ")
    }

    // MARK: - Review Row

    private func reviewRow(
        icon: String,
        title: String,
        value: String
    ) -> some View {

        HStack(spacing: 14) {

            Image(systemName: icon)
                .foregroundStyle(.tint)
                .frame(width: 24)

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.trailing)
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
}
