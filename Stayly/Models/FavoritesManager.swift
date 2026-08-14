import Foundation
import Combine

final class FavoritesManager: ObservableObject {
    
    @Published private(set) var favoriteIDs: Set<UUID> = []
    
    private let key = "stayly_favorite_ids"
    
    init() {
        loadFavorites()
    }
    
    func toggleFavorite(_ property: Property) {
        if favoriteIDs.contains(property.id) {
            favoriteIDs.remove(property.id)
        } else {
            favoriteIDs.insert(property.id)
        }
        
        saveFavorites()
    }
    
    func isFavorite(_ property: Property) -> Bool {
        favoriteIDs.contains(property.id)
    }
    
    private func saveFavorites() {
        let ids = favoriteIDs.map { $0.uuidString }
        UserDefaults.standard.set(ids, forKey: key)
    }
    
    private func loadFavorites() {
        guard let savedIDs = UserDefaults.standard.array(
            forKey: key
        ) as? [String] else {
            return
        }
        
        favoriteIDs = Set(
            savedIDs.compactMap {
                UUID(uuidString: $0)
            }
        )
    }
}
