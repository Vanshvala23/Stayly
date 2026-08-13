import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "magnifyingglass")
                }

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }

            TripsView()
                .tabItem {
                    Label("Trips", systemImage: "suitcase")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }.tint(Color.staylyPrimary)
    }
}
extension Color{
    static let staylyPrimary=Color(red:1.0,green:0.22,blue:0.36)
}
#Preview {
    MainTabView()
}
