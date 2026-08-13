import SwiftUI

struct ExploreView: View {
    
    let properties = [
        Property(
            title: "Modern Mountain Cabin",
            location: "Manali, India",
            price: 4500,
            rating: 4.92,
            imageName: "cabin"
        ),
        Property(
            title: "Beachfront Villa",
            location: "Goa, India",
            price: 6200,
            rating: 4.87,
            imageName: "beach"
        ),
        Property(
            title: "Luxury City Apartment",
            location: "Mumbai, India",
            price: 3800,
            rating: 4.81,
            imageName: "city"
        )
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    SearchBar()
                    
                    CategoryScrollView()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("Stayly picks")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.leading)
                        ForEach(properties) { property in
                            PropertyCard(property: property)
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
            .navigationTitle("Stayly")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    ExploreView()
}
