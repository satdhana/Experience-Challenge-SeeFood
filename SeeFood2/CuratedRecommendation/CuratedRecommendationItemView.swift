//
//  CuratedRecommendationItemView.swift
//  SeeFood2
//
//  Created by Satria Dafa Putra Wardhana on 09/05/25.
//

import SwiftUI

struct CuratedRecommendationItemView: View {
    let imageName: String
    let title: String
    let location: String
    let description: String
    let price: String

    var body: some View {
        HStack(spacing: 12) {
            // Bagian Gambar
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 120) // Sesuaikan lebar gambar
                .clipped()

            // Bagian Informasi Teks
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
                    Image(systemName: "star")
                        .foregroundColor(.gray.opacity(0.7))
                }
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
        .frame(width: .infinity, height: 130
        ) // Sesuaikan lebar keseluruhan item
        .background(Color.white) // Berikan background putih
        .cornerRadius(10) // Tambahkan corner radius
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 16) // Padding untuk item terakhir
    }
}

struct CuratedRecommendationItemView_Previews: PreviewProvider {
    static var previews: some View {
        CuratedRecommendationItemView(
            imageName: "MB-1",
            title: "Panekuk",
            location: "The Breeze | 500m",
            description: "Panekuk dengan taburan kacang dan krim susu",
            price: "Rp 38.000,-"
        )
        .previewLayout(.sizeThatFits)
    }
}
