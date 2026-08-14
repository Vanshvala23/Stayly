import SwiftUI

struct PropertyDetailView: View {
    
    let property: Property
    
    @State private var isFavorite = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                
                // MARK: - Property Image
                
                ZStack(alignment: .topTrailing) {
                    
                    Image(property.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(
                            maxWidth: .infinity,
                            minHeight: 150
                        )
                        .clipped()
                    
                    HStack(spacing: 10) {
                        
                        ShareLink(
                            item: "\(property.title) - \(property.location)"
                        ) {
                            Image(
                                systemName: "square.and.arrow.up"
                            )
                            .font(.title3)
                            .foregroundStyle(.white)
                            .frame(width: 42, height: 42)
                            .background(
                                .black.opacity(0.35)
                            )
                            .clipShape(Circle())
                        }
                        
                        Button {
                            withAnimation(
                                .spring(
                                    response: 0.3,
                                    dampingFraction: 0.6
                                )
                            ) {
                                isFavorite.toggle()
                            }
                        } label: {
                            Image(
                                systemName: isFavorite
                                ? "heart.fill"
                                : "heart"
                            )
                            .font(.title3)
                            .foregroundStyle(
                                isFavorite ? .red : .white
                            )
                            .frame(width: 42, height: 42)
                            .background(
                                .black.opacity(0.35)
                            )
                            .clipShape(Circle())
                        }
                    }
                    .padding(16)
                }
                
                // MARK: - Details
                
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Title
                    VStack(
                        alignment: .leading,
                        spacing: 8
                    ) {
                        
                        Text(property.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .fixedSize(
                                horizontal: false,
                                vertical: true
                            )
                        
                        HStack(spacing: 6) {
                            
                            Image(
                                systemName: "mappin.and.ellipse"
                            )
                            
                            Text(property.location)
                                .fixedSize(
                                    horizontal: false,
                                    vertical: true
                                )
                        }
                        .foregroundStyle(.secondary)
                    }
                    
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
                        
                        Text("·")
                            .foregroundStyle(.secondary)
                        
                        Text(
                            "\(property.reviewCount) reviews"
                        )
                        .foregroundStyle(.secondary)
                    }
                    
                    Divider()
                    
                    // MARK: - Property Stats
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 16
                    ) {
                        
                        PropertyStat(
                            icon: "person.2.fill",
                            value: "\(property.guests)",
                            title: "Guests"
                        )
                        
                        PropertyStat(
                            icon: "bed.double.fill",
                            value: "\(property.bedrooms)",
                            title: "Bedrooms"
                        )
                        
                        PropertyStat(
                            icon: "bed.double",
                            value: "\(property.beds)",
                            title: "Beds"
                        )
                        
                        PropertyStat(
                            icon: "shower.fill",
                            value: "\(property.bathrooms)",
                            title: "Baths"
                        )
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    // MARK: - Host
                    
                    HStack(spacing: 12) {
                        
                        Image(
                            systemName: "person.circle.fill"
                        )
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                        
                        VStack(
                            alignment: .leading,
                            spacing: 4
                        ) {
                            
                            Text(
                                "Hosted by \(property.hostName)"
                            )
                            .fontWeight(.semibold)
                            
                            Text("Experienced host")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    // MARK: - About
                    
                    VStack(
                        alignment: .leading,
                        spacing: 10
                    ) {
                        
                        Text("About this place")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text(property.description)
                            .foregroundStyle(.secondary)
                            .lineSpacing(4)
                            .fixedSize(
                                horizontal: false,
                                vertical: true
                            )
                    }
                    
                    Divider()
                    
                    // MARK: - Amenities
                    
                    VStack(
                        alignment: .leading,
                        spacing: 16
                    ) {
                        
                        Text("What this place offers")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            alignment: .leading,
                            spacing: 18
                        ) {
                            
                            ForEach(
                                property.amenities,
                                id: \.name
                            ) { amenity in
                                
                                HStack(spacing: 10) {
                                    
                                    Image(
                                        systemName: amenity.icon
                                    )
                                    .frame(width: 24)
                                    
                                    Text(amenity.name)
                                        .font(.subheadline)
                                        .lineLimit(1)
                                    
                                    Spacer(minLength: 0)
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    // MARK: - Reviews
                    
                    VStack(
                        alignment: .leading,
                        spacing: 16
                    ) {
                        
                        Text("Guest reviews")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
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
                            
                            Text("·")
                                .foregroundStyle(.secondary)
                            
                            Text(
                                "\(property.reviewCount) reviews"
                            )
                            .foregroundStyle(.secondary)
                        }
                        
                        VStack(
                            alignment: .leading,
                            spacing: 8
                        ) {
                            
                            Text(
                                "“Beautiful property with amazing views. "
                                + "The place was clean, comfortable, and "
                                + "perfect for a relaxing stay.”"
                            )
                            .foregroundStyle(.secondary)
                            .lineSpacing(3)
                            
                            Text("— Rahul")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    Divider()
                    
                    // MARK: - Location
                    
                    VStack(
                        alignment: .leading,
                        spacing: 12
                    ) {
                        
                        Text("Where you'll be")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        HStack(spacing: 8) {
                            
                            Image(
                                systemName: "mappin.and.ellipse"
                            )
                            
                            Text(property.location)
                                .foregroundStyle(.secondary)
                        }
                        
                        RoundedRectangle(
                            cornerRadius: 16
                        )
                        .fill(.quaternary)
                        .frame(
                            maxWidth: .infinity,
                            minHeight: 180,
                            maxHeight: 180
                        )
                        .overlay {
                            
                            VStack(spacing: 8) {
                                
                                Image(
                                    systemName: "map.fill"
                                )
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                                
                                Text("Map")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
        }
        .safeAreaInset(edge: .bottom) {
            reservationBar
        }
        .navigationTitle("Property")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Reservation Bar
    
    private var reservationBar: some View {
        HStack(spacing: 16) {
            
            VStack(
                alignment: .leading,
                spacing: 3
            ) {
                
                Text("₹\(property.price)")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text("per night")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer(minLength: 0)
            
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
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(.regularMaterial)
        .overlay(alignment: .top) {
            Divider()
        }
    }
}

// MARK: - Property Stat

struct PropertyStat: View {
    
    let icon: String
    let value: String
    let title: String
    
    var body: some View {
        VStack(spacing: 6) {
            
            Image(systemName: icon)
                .font(.headline)
            
            Text(value)
                .fontWeight(.semibold)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(
            maxWidth: .infinity
        )
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
                    category: "Cabins",
                    description: "Enjoy a peaceful stay surrounded by the beautiful mountains of Manali. This cozy cabin is perfect for relaxing, exploring the area, and spending quality time away from the city.",
                    hostName: "Vijay",
                    reviewCount: 128,
                    guests: 4,
                    bedrooms: 2,
                    beds: 2,
                    bathrooms: 1,
                    amenities: [
                        Amenity(
                            icon: "wifi",
                            name: "Free Wi-Fi"
                        ),
                        Amenity(
                            icon: "car.fill",
                            name: "Free parking"
                        ),
                        Amenity(
                            icon: "fork.knife",
                            name: "Kitchen"
                        ),
                        Amenity(
                            icon: "snowflake",
                            name: "Air conditioning"
                        ),
                        Amenity(
                            icon: "mountain.2.fillname:", name:"Mountain view"
                        ),
                        Amenity(
                            icon: "laptopcomputer",
                            name: "Workspace"
                        )
                    ]
                )
            )
}
}
