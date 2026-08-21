import SwiftUI
import Combine

final class TabNavigationManager: ObservableObject {
    
    @Published var selectedTab: Int = 0
    
    func goToTrips() {
        selectedTab = 2
    }
}
