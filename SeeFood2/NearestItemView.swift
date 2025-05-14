//
//  NearestItemView.swift
//  SeeFood2
//
//  Created by Satria Dafa Putra Wardhana on 09/05/25.
//

import SwiftUI

struct NearestHereListItemView: View {
    let imageName: String
    let title: String
    let location: String
    let openHours: String
    let phoneNumber: String
    let priceRange: String

    var body: some View {
        HStack(spacing: 16) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)

                HStack(spacing: 4) {
                    Image(systemName: "mappin.fill")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(location)
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                HStack(spacing: 4) {
                    Image(systemName: "clock.fill")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(openHours)
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                HStack(spacing: 4) {
                    Image(systemName: "phone.fill")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(phoneNumber)
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                HStack(spacing: 4) {
                    Image(systemName: "tag.fill")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(priceRange)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        .padding(.horizontal)
    }
}

struct NearestHereListItemView_Previews: PreviewProvider {
    static var previews: some View {
        NearestHereListItemView(
            imageName: "M",
            title: "Mama Jempol",
            location: "GOP 9 | 50m",
            openHours: "9:00 - 14:00",
            phoneNumber: "+62089988781345",
            priceRange: "Rp 15.000 - Rp 55.000"
        )
        .previewLayout(.sizeThatFits)
    }
}
