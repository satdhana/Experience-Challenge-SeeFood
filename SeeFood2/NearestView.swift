import SwiftUI

struct NearestView: View {
    let favoriteRecommendations: [Recommendation] = [
        Recommendation(imageName: "MB-1", title: "Panekuk", location: "The Breeze | 500m", description: "Panekuk dengan taburan kacang dan krim susu", price: "Rp 38.000,-"),
        Recommendation(imageName: "MB-2", title: "Smoothies", location: "GOP 9 | 50m", description: "Campuran buah yang dihaluskan dengan taburan buah potong", price: "Rp 37.000,-"),
        Recommendation(imageName: "MB-3", title: "Soda Gembira", location: "Traveloka Campus | 900m", description: "Es soda dengan sirup perasa buah yang segar", price: "Rp 35.000,-"),
        Recommendation(imageName: "MB-4", title: "Roti Isi", location: "GOP 6 | 300m", description: "Roti gandum dengan isian sayur, buah, daging, telur yang bergizi", price: "Rp 45.000,-"),
        Recommendation(imageName: "MB-5", title: "Air Infus", location: "The Breeze | 500m", description: "Air mineral dingin dengan isian buah jeruk nipis atau mentimun", price: "Rp 21.000,-"),
        Recommendation(imageName: "MB-6", title: "Pizza", location: "GOP 9 | 50m", description: "Pizza dengan pilihan isian dari daging, sayur, dan keju", price: "Rp 35.000,-"),
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header dengan Background Image
            ZStack {
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 110)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 0) {
                    // Header Content
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Lokasi Terdekat")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Color.clear.frame(width: 24, height: 24)
                    }
                    .padding(.horizontal,24)
                    .background(Color("OrangeBackground").opacity(0.8))
                }
                .padding(.top, 40)
            }
            .frame(height: 140)
            
            // List Rekomendasi
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(favoriteRecommendations) { recommendation in
                        CuratedRecommendationItemView(
                            imageName: recommendation.imageName,
                            title: recommendation.title,
                            location: recommendation.location,
                            description: recommendation.description,
                            price: recommendation.price
                        )
                    }
                }
                .padding(.vertical)
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}



struct NearestView_Previews: PreviewProvider {
    static var previews: some View {
        NearestView()
    }
}
