import SwiftUI
struct PropertyDetailView:View{
    let property: Property
        
        @State private var isFavorite = false
        
        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Property Image
                    ZStack(alignment: .topTrailing) {
                        
                        Image(property.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(
                                maxWidth: .infinity,
                                minHeight: 300,
                                maxHeight: 380
                            )
                            .clipped()
                        
                        Button {
                            withAnimation(.spring(
                                response: 0.3,
                                dampingFraction: 0.6
                            )) {
                                isFavorite.toggle()
                            }
                        } label: {
                            Image(
                                systemName: isFavorite
                                ? "heart.fill"
                                : "heart"
                            )
                            .font(.title2)
                            .foregroundStyle(
                                isFavorite ? .red : .white
                            )
                            .padding(12)
                            .background(
                                .black.opacity(0.35)
                            )
                            .clipShape(Circle())
                            .scaleEffect(
                                isFavorite ? 1.1 : 1.0
                            )
                        }
                        .padding(16)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // Title
                        Text(property.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        // Location
                        HStack(spacing: 6) {
                            Image(systemName: "mappin.and.ellipse")
                            
                            Text(property.location)
                        }
                        .foregroundStyle(.secondary)
                        
                        // Rating
                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                            
                            Text(
                                String(
                                    format: "%.2f",
                                    property.rating
                                )
                            )
                            .fontWeight(.semibold)
                        }
                        
                        Divider()
                        
                        // About
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text("About this place")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text(
                                "Enjoy a comfortable and memorable stay "
                                + "in this beautiful property. Perfect for "
                                + "relaxing, exploring the area, and enjoying "
                                + "everything the destination has to offer."
                            )
                            .foregroundStyle(.secondary)
                            .lineSpacing(4)
                        }
                        
                        Divider()
                        
                        // Category
                        HStack {
                            Image(systemName: "house.fill")
                            
                            VStack(alignment: .leading) {
                                Text("Property type")
                                    .fontWeight(.semibold)
                                
                                Text(property.category)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("₹\(property.price)")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Text("per night")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Button {
                        // Reservation action
                    } label: {
                        Text("Reserve")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 14)
                            .background(.tint)
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 14
                                )
                            )
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(.regularMaterial)
            }
            .navigationTitle("Property")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
#Preview{
NavigationStack {
    PropertyDetailView(
        property: Property(
            title: "Modern Mountain Cabin",
            location: "Manali, India",
            price: 4500,
            rating: 4.92,
            imageName: "cabin",
            category: "Cabins"
        )
    )
}
}
