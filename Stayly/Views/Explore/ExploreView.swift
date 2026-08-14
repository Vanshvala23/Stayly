import SwiftUI

struct ExploreView: View {
    
    @State private var searchText = ""
    
    let properties:[Property]
    
    // MARK: - Filtered Properties
    
    private var filteredProperties: [Property] {
        
        let query = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if query.isEmpty {
            return properties
        }
        
        return properties.filter { property in
            property.title.localizedCaseInsensitiveContains(query) ||
            property.location.localizedCaseInsensitiveContains(query) ||
            property.category.localizedCaseInsensitiveContains(query)
        }
    }
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: Search
                    
                    SearchBar(
                        searchText: $searchText,
                        selectedProperty: .constant(nil),
                        properties: properties
                    )
                    .padding(.horizontal)
                    
                    // MARK: Categories
                    
                    CategoryScrollView(
                        properties: properties
                    )
                    
                    // MARK: Properties
                    
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text(
                            searchText.isEmpty
                            ? "Stayly picks"
                            : "Search results"
                        )
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading)
                        
                        if filteredProperties.isEmpty {
                            
                            VStack(spacing: 10) {
                                
                                Image(systemName: "magnifyingglass")
                                    .font(.largeTitle)
                                    .foregroundStyle(.secondary)
                                
                                Text("No stays found")
                                    .font(.headline)
                                
                                Text("Try searching for another destination.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                            
                        } else {
                            
                            ForEach(filteredProperties) { property in
                                PropertyCard(property: property)
                            }
                        }
                    }
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
            }
            .background(Color(.systemBackground))
            .navigationTitle("Stayly")
            .navigationBarTitleDisplayMode(.large)
           
        }
    }
}

#Preview {
    ExploreView(properties:staylyProperties)
}
