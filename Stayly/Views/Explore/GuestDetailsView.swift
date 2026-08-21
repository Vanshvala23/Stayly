import SwiftUI

struct GuestDetailsView: View {

    let adults: Int
    let children: Int

    @State private var guests: [Guest] = []

    let onContinue: ([Guest]) -> Void

    var body: some View {

        Form {

            // MARK: - Adults

            Section {

                ForEach(
                    guests.indices.filter {
                        guests[$0].type == .adult
                    },
                    id: \.self
                ) { index in

                    TextField(
                        "Adult \(adultNumber(for: index)) name",
                        text: $guests[index].name
                    )
                    .textInputAutocapitalization(.words)
                }

            } header: {

                Label(
                    "Adults",
                    systemImage: "person.fill"
                )
            }

            // MARK: - Children

            if children > 0 {

                Section {

                    ForEach(
                        guests.indices.filter {
                            guests[$0].type == .child
                        },
                        id: \.self
                    ) { index in

                        TextField(
                            "Child \(childNumber(for: index)) name",
                            text: $guests[index].name
                        )
                        .textInputAutocapitalization(.words)
                    }

                } header: {

                    Label(
                        "Children",
                        systemImage: "figure.and.child.holdinghands"
                    )
                }
            }
        }
        .navigationTitle("Guest Details")
        .navigationBarTitleDisplayMode(.inline)

        .toolbar {

            ToolbarItem(
                placement: .navigationBarTrailing
            ) {

                Button("Continue") {
                    let cleanedGuests = guests.map { guest in
                        Guest(
                            name: guest.name.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ),
                            type: guest.type
                        )
                    }

                    onContinue(cleanedGuests)
                }
                .fontWeight(.semibold)
            }
        }

        .onAppear {
            setupGuests()
        }
    }

    // MARK: - Setup Guests

    private func setupGuests() {

        guard guests.isEmpty else {
            return
        }

        guests = (0..<adults).map { _ in
            Guest(type: .adult)
        }

        guests += (0..<children).map { _ in
            Guest(type: .child)
        }
    }

    // MARK: - Adult Number

    private func adultNumber(for index: Int) -> Int {

        guests[0...index].filter {
            $0.type == .adult
        }.count
    }

    // MARK: - Child Number

    private func childNumber(for index: Int) -> Int {

        guests[0...index].filter {
            $0.type == .child
        }.count
    }

    // MARK: - Validation

    private var isValid: Bool {

        guests.count == adults + children &&
        guests.allSatisfy {

            !$0.name
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
                .isEmpty
        }
    }
}
