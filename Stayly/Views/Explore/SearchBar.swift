import SwiftUI

struct SearchBar: View {
    
    @Binding var searchText: String
    @Binding var selectedProperty: Property?
    
    let properties: [Property]
    
    @FocusState private var isSearching: Bool
    @State private var showSearchPanel = false
    
    private var filteredProperties: [Property] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return properties
        }
        
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return properties.filter { property in
            property.title.localizedCaseInsensitiveContains(query) ||
            property.location.localizedCaseInsensitiveContains(query)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: Search Header
            
            HStack(spacing: 12) {
                
                Image(systemName: "magnifyingglass")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                
                TextField(
                    "Where do you want to go?",
                    text: $searchText
                )
                .font(.subheadline)
                .fontWeight(.medium)
                .focused($isSearching)
                .submitLabel(.search)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                        isSearching = true
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.background)
            
            // MARK: Results
            
            if showSearchPanel {
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    Divider()
                        .padding(.horizontal, 16)
                    
                    if searchText.isEmpty {
                        
                        Text("Explore stays")
                            .font(.headline)
                            .padding(.horizontal, 16)
                            .padding(.top, 18)
                            .padding(.bottom, 10)
                        
                    } else {
                        
                        Text("Matching stays")
                            .font(.headline)
                            .padding(.horizontal, 16)
                            .padding(.top, 18)
                            .padding(.bottom, 10)
                    }
                    
                    if filteredProperties.isEmpty {
                        
                        VStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                            
                            Text("No stays found")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Text("Try another destination")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                        
                    } else {
                        
                        ForEach(filteredProperties) { property in
                            
                            Button {
                                selectProperty(property)
                            } label: {
                                HStack(spacing: 12) {
                                    
                                    Image(property.imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .clipShape(
                                            RoundedRectangle(
                                                cornerRadius: 10
                                            )
                                        )
                                    
                                    VStack(
                                        alignment: .leading,
                                        spacing: 4
                                    ) {
                                        
                                        Text(property.title)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.primary)
                                            .lineLimit(1)
                                        
                                        Text(property.location)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        
                                        HStack(spacing: 4) {
                                            Image(systemName: "star.fill")
                                                .font(.caption2)
                                            
                                            Text(
                                                String(
                                                    format: "%.2f",
                                                    property.rating
                                                )
                                            )
                                            .font(.caption)
                                        }
                                        .foregroundStyle(.secondary)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    Divider()
                        .padding(.top, 8)
                    
                    Button {
                        closeSearch()
                    } label: {
                        Text("Cancel")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                    .buttonStyle(.plain)
                }
                .background(.background)
            }
        }
        .background(.background)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.quaternary, lineWidth: 1)
        }
        .shadow(
            color: .black.opacity(0.08),
            radius: 10,
            y: 4
        )
        .onChange(of: isSearching) { _, searching in
            withAnimation(.easeInOut(duration: 0.2)) {
                showSearchPanel = searching
            }
        }
    }
    
    // MARK: Actions
    
    private func selectProperty(_ property: Property) {
        selectedProperty = property
        searchText = property.location
        
        isSearching = false
        
        withAnimation(.easeInOut(duration: 0.2)) {
            showSearchPanel = false
        }
        
        hideKeyboard()
    }
    
    private func closeSearch() {
        isSearching = false
        
        withAnimation(.easeInOut(duration: 0.2)) {
            showSearchPanel = false
        }
        
        hideKeyboard()
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
#Preview {
    SearchBar(
        searchText: .constant(""),
        selectedProperty: .constant(nil),
        properties: [
            Property(
                title: "Modern Mountain Cabin",
                location: "Manali, India",
                price: 4500,
                rating: 4.92,
                imageName: "cabin",
                category: "Cabins",
                description: "Enjoy a peaceful stay surrounded by the beautiful mountains of Manali.",
                hostName: "Vijay",
                reviewCount: 128,
                guests: 4,
                bedrooms: 2,
                beds: 2,
                bathrooms: 1,
                amenities: [
                    Amenity(icon: "wifi", name: "Free Wi-Fi"),
                    Amenity(icon: "car.fill", name: "Free parking"),
                    Amenity(icon: "fork.knife", name: "Kitchen")
                ]
            ),
            
            Property(
                title: "Beachfront Villa",
                location: "Goa, India",
                price: 6200,
                rating: 4.87,
                imageName: "beach",
                category: "Beach",
                description: "Relax in this beautiful beachfront villa with stunning ocean views.",
                hostName: "Aarav",
                reviewCount: 96,
                guests: 6,
                bedrooms: 3,
                beds: 3,
                bathrooms: 2,
                amenities: [
                    Amenity(icon: "wifi", name: "Free Wi-Fi"),
                    Amenity(icon: "water.waves", name: "Beach access"),
                    Amenity(icon: "car.fill", name: "Free parking")
                ]
            ),
            
            Property(
                title: "Luxury City Apartment",
                location: "Mumbai, India",
                price: 3800,
                rating: 4.81,
                imageName: "city",
                category: "Cities",
                description: "A modern city apartment in the heart of Mumbai.",
                hostName: "Riya",
                reviewCount: 74,
                guests: 3,
                bedrooms: 1,
                beds: 2,
                bathrooms: 1,
                amenities: [
                    Amenity(icon: "wifi", name: "Free Wi-Fi"),
                    Amenity(icon: "building.2.fill", name: "City view"),
                    Amenity(icon: "car.fill", name: "Free parking")
                ]
            )
        ]
    )
    .padding()
}
