//
//  NearestHereItemView.swift
//  SeeFood2
//
//  Created by Satria Dafa Putra Wardhana on 07/05/25.
//

import SwiftUI

struct NearestHereItemView: View {
    let imageName: String // Nama aset logo Mama Djempol
    let placeName: String
    let locationInfo: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 130)
                .background(Color.white)
            
            Text(placeName)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            
            Text(locationInfo)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 12)
        }
        .frame(width: 130, height: 180) // Sesuaikan lebar setiap item
        .background(Color.white) // Pastikan background putih di sini juga
        .cornerRadius(15) // Corner radius yang sama dengan logo background
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2) // Shadow yang sama
    }
}

struct NearestHereCarouselView: View {
    let nearestPlaces: [NearestPlace] = [
        NearestPlace(imageName: "A", placeName: "Uena", locationInfo: "The Breeze | 500m"),
        NearestPlace(imageName: "M", placeName: "Mama Jempol", locationInfo: "GOP 9 | 50m"),
        NearestPlace(imageName: "K", placeName: "Kasturi", locationInfo: "GOP 9 | 50m"),
        NearestPlace(imageName: "L", placeName: "Wisteria", locationInfo: "The Breeze | 750m"),
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Lokasi Terdekat")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                NavigationLink(destination: NearestView()){
                    Text("Lihat Semua")
                        .font(.caption)
                        .foregroundColor(Color(.orange))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(.white))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.orange), lineWidth: 1)
                        )
                }
                
            }
            .padding(.horizontal, 28)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(nearestPlaces) { place in
                        NearestHereItemView(
                            imageName: place.imageName,
                            placeName: place.placeName,
                            locationInfo: place.locationInfo
                        )
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 20)
            }
            .clipShape(Rectangle())
        }
    }
}

struct NearestPlace: Identifiable {
    let id = UUID()
    let imageName: String
    let placeName: String
    let locationInfo: String
}

struct NearestHereCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        NearestHereCarouselView()
            .previewLayout(.sizeThatFits)
    }
}
