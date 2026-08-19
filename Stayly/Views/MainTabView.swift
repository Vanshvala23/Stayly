import SwiftUI

struct MainTabView: View {
    @StateObject private var favoritesManager = FavoritesManager()
    @StateObject private var bookingManager=BookingManager()
    var body: some View {
        TabView {
            ExploreView(properties: staylyProperties)
                .tabItem {
                    Label("Explore", systemImage: "magnifyingglass")
                }

            FavoritesView(properties: staylyProperties)
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
        }.tint(Color.staylyPrimary).environmentObject(favoritesManager)
            .environmentObject(bookingManager)
    }
}
extension Color{
    static let staylyPrimary=Color(.pink)
}
#Preview {
    MainTabView()
}
