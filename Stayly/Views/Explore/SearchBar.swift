import SwiftUI

struct SearchBar: View {
    var body: some View {
        HStack(spacing: 12) {
            
            Image(systemName: "magnifyingglass")
                .font(.title3)
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading, spacing: 3) {
                Text("Where do you want to go?")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("Anywhere · Any week · Add guests")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer(minLength: 8)
            
            Image(systemName: "slider.horizontal.3")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
                .padding(10)
                .background(.quaternary.opacity(0.35))
                .clipShape(Circle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.quaternary, lineWidth: 1)
        }
        .shadow(
            color: .black.opacity(0.06),
            radius: 8,
            y: 3
        )
    }
}

#Preview {
    SearchBar()
        .padding()
}
