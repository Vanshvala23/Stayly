import SwiftUI

struct PropertyCard: View {
    
    @State private var isFav = false
    
    let property: Property
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // MARK: - Property Image
            
            ZStack(alignment: .topTrailing) {
                
                NavigationLink {
                    PropertyDetailView(
                        property: property
                    )
                } label: {
                    Image(property.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 240)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 18
                            )
                        )
                }
                .buttonStyle(.plain)
                
                // Favorite button
                Button {
                    withAnimation(
                        .spring(
                            response: 0.3,
                            dampingFraction: 0.5
                        )
                    ) {
                        isFav.toggle()
                    }
                } label: {
                    Image(
                        systemName: isFav
                        ? "heart.fill"
                        : "heart"
                    )
                    .font(.title3)
                    .foregroundStyle(
                        isFav ? .red : .white
                    )
                    .padding(10)
                    .background(
                        .black.opacity(0.25)
                    )
                    .clipShape(Circle())
                    .scaleEffect(
                        isFav ? 1.15 : 1.0
                    )
                }
                .padding(12)
            }
            
            // MARK: - Property Information
            
            NavigationLink {
                PropertyDetailView(
                    property: property
                )
            } label: {
                VStack(alignment: .leading, spacing: 8) {
                    
                    HStack {
                        
                        Text(property.title)
                            .font(.headline)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            
                            Image(systemName: "star.fill")
                                .font(.caption)
                            
                            Text(
                                String(
                                    format: "%.2f",
                                    property.rating
                                )
                            )
                            .font(.subheadline)
                        }
                    }
                    
                    Text(property.location)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 4) {
                        
                        Text("₹\(property.price)")
                            .fontWeight(.semibold)
                        
                        Text("night")
                            .foregroundStyle(.secondary)
                    }
                    .font(.subheadline)
                }
                .foregroundStyle(.primary)
                .padding(.horizontal)
            }
            .buttonStyle(.plain)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }
}

#Preview {
    NavigationStack {
        PropertyCard(
            property: Property(
                title: "Modern Mountain Cabin",
                location: "Manali, India",
                price: 4500,
                rating: 4.92,
                imageName: "cabin",
                category: "Cabins"
            )
        )
        .padding()
    }
}
