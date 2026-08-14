import SwiftUI

struct FavoritesView: View {
    
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    let properties: [Property]
    
    private var favoriteProperties: [Property] {
        properties.filter {
            favoritesManager.isFavorite($0)
        }
    }
    
    var body: some View {
        NavigationStack {
            
            Group {
                if favoriteProperties.isEmpty {
                    
                    ContentUnavailableView(
                        "No Favorites",
                        systemImage: "heart",
                        description: Text(
                            "Places you save will appear here."
                        )
                    )
                    
                } else {
                    
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(favoriteProperties) { property in
                                PropertyCard(property: property)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
