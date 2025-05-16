import SwiftUI

struct RecommendationItemView: View {
    let imageName: String // Nama aset gambar pizza
    let title: String
    let location: String
    let description: String
    let price: String
    
    var body: some View {
        HStack(spacing: 0) {
            // Bagian Gambar
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 130) // Sesuaikan lebar gambar
                .clipped()
            
            // Bagian Informasi Teks
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .fontWeight(.bold)
                        HStack(spacing: 4) {
                            Image(systemName: "mappin.fill")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            Text(location)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                    Image(systemName: "star")
                        .foregroundColor(.gray.opacity(0.7))
                }
                
                Spacer()
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(price)
                    .font(.subheadline)
                    .foregroundColor(.blue) // Atau warna lain untuk harga
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .frame(width: 330) // Sesuaikan lebar keseluruhan item
        .background(Color.white) // Berikan background putih
        .cornerRadius(10) // Tambahkan corner radius
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.leading, 16) // Padding untuk item terakhir
    }
}

struct RecommendationCarouselView: View {
    let recommendations: [RecommendationItem] = [
        RecommendationItem(imageName: "MB-1", title: "Pizza", location: "GOP 9 | 50m", description: "Pizza dengan pilihan isian dari daging, sayur, dan keju", price: "Rp 35.000,-"),
        RecommendationItem(imageName: "MB-2", title: "Burger", location: "BSD | 1km", description: "Burger lezat dengan daging sapi premium", price: "Rp 45.000,-"),
        RecommendationItem(imageName: "MB-3", title: "Pizza", location: "GOP 9 | 50m", description: "Pizza dengan pilihan isian dari daging, sayur, dan keju", price: "Rp 35.000,-"),
        RecommendationItem(imageName: "MB-4", title: "Burger", location: "BSD | 1km", description: "Burger lezat dengan daging sapi premium", price: "Rp 45.000,-"),
        RecommendationItem(imageName: "MB-5", title: "Pizza", location: "GOP 9 | 50m", description: "Pizza dengan pilihan isian dari daging, sayur, dan keju", price: "Rp 35.000,-"),
        RecommendationItem(imageName: "MB-6", title: "Burger", location: "BSD | 1km", description: "Burger lezat dengan daging sapi premium", price: "Rp 45.000,-"),
    ]
    
    @Binding var showNavigationButton: Bool
    @Binding var isMapActive: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Rekomendasi Terpopuler")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                NavigationLink(destination: CuratedRecommendationsView()) {
                    Text("Lihat Semua")
                        .font(.caption)
                        .foregroundColor(Color(.orange))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(.white).cornerRadius(8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.orange), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 28)
            .padding(.top, 12)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(recommendations) { item in
                        RecommendationItemView(
                            imageName: item.imageName,
                            title: item.title,
                            location: item.location,
                            description: item.description,
                            price: item.price
                        )
                        .onTapGesture {
                            showNavigationButton = true
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .background(Color.orange.opacity(0.4))
    }
}

// Struktur data untuk item rekomendasi
struct RecommendationItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let location: String
    let description: String
    let price: String
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isMapActive = false
        @State var showNavButton = false
        
        return RecommendationCarouselView(showNavigationButton: $showNavButton, isMapActive: $isMapActive)
            .previewLayout(.sizeThatFits)
    }
}
