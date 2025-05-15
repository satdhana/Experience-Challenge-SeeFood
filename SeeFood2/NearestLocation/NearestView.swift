import SwiftUI

struct NearestView: View {
    let nearestPlacesData: [NearestPlaceData] = [
        NearestPlaceData(imageName: "A", title: "Uena", location: "The Breeze | 500m", distanceInMeters: 500, openHours: "10:00 - 22:00", phoneNumber: "+62982345743", priceRange: "Rp 20.000 - Rp 80.000"),
        NearestPlaceData(imageName: "M", title: "Mama Jempol", location: "GOP 9 | 50m", distanceInMeters: 50, openHours: "09:00 - 14:00", phoneNumber: "+62934857323", priceRange: "Rp 15.000 - Rp 55.000"),
        NearestPlaceData(imageName: "K", title: "Kasturi", location: "GOP 9 | 55m", distanceInMeters: 55, openHours: "11:00 - 21:00", phoneNumber: "+6248756322", priceRange: "Rp 25.000 - Rp 70.000"),
        NearestPlaceData(imageName: "L", title: "Wisteria", location: "The Breeze | 750m", distanceInMeters: 750, openHours: "18:00 - 23:00", phoneNumber: "+62403895783", priceRange: "Rp 30.000 - Rp 90.000"),
        NearestPlaceData(imageName: "A", title: "Uena", location: "The Breeze | 400m", distanceInMeters: 400, openHours: "10:00 - 22:00", phoneNumber: "+62439587395", priceRange: "Rp 20.000 - Rp 80.000"),
        NearestPlaceData(imageName: "M", title: "Mama Jempol", location: "GOP 9 | 60m", distanceInMeters: 60, openHours: "09:00 - 14:00", phoneNumber: "+624398573534", priceRange: "Rp 15.000 - Rp 55.000"),
        NearestPlaceData(imageName: "K", title: "Kasturi", location: "GOP 9 | 80m", distanceInMeters: 80, openHours: "11:00 - 21:00", phoneNumber: "+62349857435", priceRange: "Rp 25.000 - Rp 70.000"),
        NearestPlaceData(imageName: "L", title: "Wisteria", location: "The Breeze | 700m", distanceInMeters: 700, openHours: "18:00 - 23:00", phoneNumber: "+623498573534", priceRange: "Rp 30.000 - Rp 90.000"),
    ]

    @State private var selectedPlace: NearestPlaceData?
    @State private var showDetailCard = false
    @State private var isMapActive = false
    @State private var internalShowNavigationButton = false
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            ZStack {
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 110)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .onTapGesture {
                                // Tambahkan aksi kembali jika diperlukan
                            }
                        Spacer()
                        Text("Lokasi Terdekat")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                        Color.clear.frame(width: 24, height: 24)
                    }
                    .padding(.horizontal, 24)
                    .background(Color("OrangeBackground").opacity(0.8))
                }
                .padding(.top, 40)
            }
            .frame(height: 140)

            // List Lokasi Terdekat
            ScrollView {
                VStack(spacing: 0) {
                        ForEach(nearestPlacesData.sorted(by: { $0.distanceInMeters < $1.distanceInMeters })) { place in
                            NearestHereListItemView(
                                imageName: place.imageName,
                                title: place.title,
                                location: place.location,
                                openHours: place.openHours,
                                phoneNumber: place.phoneNumber,
                                priceRange: place.priceRange
                            )
                            .onTapGesture {
                                selectedPlace = place
                                showDetailCard = true
                            }
                        }
                        .padding(.vertical)
                    }
            }

            // Detail Card
            if showDetailCard, let selectedPlace = selectedPlace {
                VStack(alignment: .leading) {
                    Text(selectedPlace.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(selectedPlace.location)
                        .foregroundColor(.gray)
                    Text("Buka: \(selectedPlace.openHours)")
                        .foregroundColor(.gray)
                    Text("Telp: \(selectedPlace.phoneNumber)")
                        .foregroundColor(.gray)
                    Text("Harga: \(selectedPlace.priceRange)")
                        .foregroundColor(.gray)

                    Button {
                        internalShowNavigationButton = true
                        isMapActive = true
                    } label: {
                        Text("Go to \(selectedPlace.title)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                    .padding(.top)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(1)
            }

            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .animation(.easeInOut, value: showDetailCard)
    }
}

struct NearestPlaceData: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let location: String // Tetap ada untuk ditampilkan
    let distanceInMeters: Int // Tambahkan properti jarak numerik
    let openHours: String
    let phoneNumber: String
    let priceRange: String
}

struct NearestView_Previews: PreviewProvider {
    static var previews: some View {
        NearestView()
    }
}
