//
//  YourFavoriteItemView.swift
//  SeeFood2
//
//  Created by Satria Dafa Putra Wardhana on 07/05/25.
//

import SwiftUI



struct YourFavoriteItemView: View {
    let imageName: String // Nama aset gambar
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
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .fontWeight(.bold)
                        HStack(spacing: 4) {
                            Image(systemName: "mappin")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            Text(location)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow.opacity(0.7))
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
        .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 135)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct YourFavoritesView: View {
    let favoriteItems: [FavoriteItem] = [
        FavoriteItem(imageName: "MB-1", title: "Smoothies", location: "GOP 9 | 50m", description: "Campuran buah yang dihaluskan dengan taburan buah potong", price: "Rp 37.000,-"),
        FavoriteItem(imageName: "MB-2", title: "Soda Gembira", location: "Traveloka Campus | 900m", description: "Es soda dengan sirup perasa buah yang segar", price: "Rp 35.000,-"),
        FavoriteItem(imageName: "MB-3", title: "Roti Isi", location: "GOP 6 | 300m", description: "Roti gandum dengan isian sayur, buah, daging, telur yang bergizi", price: "Rp 45.000,-"),
        // Tambahkan lebih banyak item favorit di sini
    ]
    
    @Binding var showNavigationButton: Bool
    @Binding var isMapActive: Bool
    @State private var selectedFavoriteItem: FavoriteItem? = nil
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                HStack(alignment: .bottom) {
                    Text("Favorit Kamu")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.top)
                    Spacer()
                    NavigationLink(destination: YourFavoriteView(showNavigationButton: $showNavigationButton, isMapActive: $isMapActive)) {
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
                
                ForEach(favoriteItems) { item in
                    YourFavoriteItemView(
                        imageName: item.imageName,
                        title: item.title,
                        location: item.location,
                        description: item.description,
                        price: item.price
                    )
                    .padding(.bottom, 10)
                    .onTapGesture {
                        selectedFavoriteItem = item
                        showNavigationButton = true
                    }
                }
                
                
                Spacer()
            }
            .padding(.horizontal,28)
        }
        
        
        
    }
}

struct FavoriteItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let location: String
    let description: String
    let price: String
}

struct YourFavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        // Deklarasikan state property di sini
        @State var isMapActive = false
        return YourFavoritesView(showNavigationButton: .constant(true), isMapActive: $isMapActive)
    }
}
