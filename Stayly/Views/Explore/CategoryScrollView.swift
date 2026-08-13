import SwiftUI

struct CategoryScrollView: View {
    
    let categories = [
        ("house.fill", "Homes"),
        ("water.waves", "Beach"),
        ("mountain.2.fill", "Mountains"),
        ("tent.fill", "Cabins"),
        ("building.2.fill", "Cities"),
        ("leaf.fill", "Nature")
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 24) {
                
                ForEach(categories, id: \.1) { category in
                    VStack(spacing: 8) {
                        Image(systemName: category.0)
                            .font(.title3)
                        
                        Text(category.1)
                            .font(.caption)
                    }
                    .frame(width: 70)
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CategoryScrollView()
        .padding()
}
