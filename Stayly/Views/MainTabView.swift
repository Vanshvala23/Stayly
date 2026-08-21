import SwiftUI

struct MainTabView: View {
    
    @StateObject private var favoritesManager = FavoritesManager()
    @StateObject private var bookingManager = BookingManager()
    @StateObject private var tabNavigationManager = TabNavigationManager()
    
    var body: some View {
        
        TabView(selection: $tabNavigationManager.selectedTab) {
            
            ExploreView(properties: staylyProperties)
                .tabItem {
                    Label(
                        "Explore",
                        systemImage: "magnifyingglass"
                    )
                }
                .tag(0)
            
            FavoritesView(properties: staylyProperties)
                .tabItem {
                    Label(
                        "Favorites",
                        systemImage: "heart"
                    )
                }
                .tag(1)
            
            TripsView()
                .tabItem {
                    Label(
                        "Trips",
                        systemImage: "suitcase"
                    )
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Label(
                        "Profile",
                        systemImage: "person"
                    )
                }
                .tag(3)
        }
        .tint(Color.staylyPrimary)
        .environmentObject(favoritesManager)
        .environmentObject(bookingManager)
        .environmentObject(tabNavigationManager)
    }
}

extension Color {
    
    static let staylyPrimary = Color(.pink)
}

#Preview {
    MainTabView()
}
