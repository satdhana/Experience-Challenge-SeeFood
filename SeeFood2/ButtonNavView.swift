//
//  ButtonNavView.swift
//  SeeFood2
//
//  Created by Satria Dafa Putra Wardhana on 14/05/25.
//

import SwiftUI

struct ButtonNavView: View {
    var body: some View {
        Button {
            print("You've Arrived! Button Tapped")
            // Handle arrival logic here
        } label: {
            HStack {
                Image(systemName: "location")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                Text("Let's Go to Restaurant!")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .background(Color.orange)
            .cornerRadius(10)
        }
        .padding()
    }
}

#Preview {
    ButtonNavView()
}
