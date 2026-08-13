import SwiftUI

struct PropertyCard: View {
    
    let property: Property
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            ZStack(alignment: .topTrailing) {
                
                Image(property.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 240)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 18)
                    )
                
                Button {
                    
                } label: {
                    Image(systemName: "heart")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(.black.opacity(0.25))
                        .clipShape(Circle())
                }
                .padding(12)
            }
            
            HStack {
                Text(property.title)
                    .font(.headline)
                    .lineLimit(1)
                    .padding(.leading)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .padding(10)
                    
                    Text(String(format: "%.2f", property.rating)).padding(15)
                        .font(.subheadline)
                }
            }
            
            Text(property.location)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.leading)
            
            HStack(spacing: 4) {
                Text("₹\(property.price)")
                    .fontWeight(.semibold)
                    .padding(.leading)
                
                Text("night")
                    .foregroundStyle(.secondary)
                    .padding(.leading)
            }
            .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PropertyCard(
        property: Property(
            title: "Modern Mountain Cabin",
            location: "Manali, India",
            price: 4500,
            rating: 4.92,
            imageName: "cabin"
        )
    )
    .padding()
}
