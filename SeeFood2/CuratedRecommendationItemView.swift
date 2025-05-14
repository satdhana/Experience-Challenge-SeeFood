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
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipped()
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)

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
                        .foregroundColor(Color(.systemYellow).opacity(0.7))
                }

                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)

                Text(price)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        .padding(.horizontal)
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
