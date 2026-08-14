import SwiftUI

struct CategoryScrollView: View {
    
    let properties: [Property]
    
    let categories = [
        ("square.grid.2x2.fill", "All"),
        ("house.fill", "Home"),
        ("water.waves", "Beach"),
        ("mountain.2.fill", "Mountains"),
        ("tent.fill", "Cabins"),
        ("building.2.fill", "Cities"),
        ("leaf.fill", "Nature")
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 24) {
                
                ForEach(categories, id: \.1) { category in
                    
                    NavigationLink {
                        CategoryView(
                            icon: category.0,
                            title: category.1,
                            properties: properties
                        )
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: category.0)
                                .font(.title3)
                            
                            Text(category.1)
                                .font(.caption)
                        }
                        .foregroundStyle(.primary)
                        .frame(width: 70)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity)
    }
}

struct CategoryView: View {
    
    let icon: String
    let title: String
    let properties: [Property]
    
    var filteredProperties: [Property] {
        if title == "All" {
            return properties
        }
        
        return properties.filter {
            $0.category == title
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                
                ForEach(filteredProperties) { property in
                    PropertyCard(property: property)
                }
            }
            .padding()
        }
        .navigationTitle(title)
    }
}

#Preview {
    NavigationStack {
        CategoryScrollView(
            properties: [
                Property(
                    title: "Modern Mountain Cabin",
                    location: "Manali, India",
                    price: 4500,
                    rating: 4.92,
                    imageName: "cabin",
                    category: "Cabins",
                    description: "Enjoy a peaceful stay surrounded by the beautiful mountains of Manali. This cozy cabin is perfect for relaxing and exploring the area.",
                    hostName: "Vijay",
                    reviewCount: 128,
                    guests: 4,
                    bedrooms: 2,
                    beds: 2,
                    bathrooms: 1,
                    amenities: [
                        Amenity(icon: "wifi", name: "Free Wi-Fi"),
                        Amenity(icon: "car.fill", name: "Free parking"),
                        Amenity(icon: "fork.knife", name: "Kitchen"),
                        Amenity(icon: "mountain.2.fill", name: "Mountain view")
                    ]
                )
            ]
        )
    }
}
