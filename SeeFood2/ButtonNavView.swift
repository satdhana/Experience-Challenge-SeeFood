//
//  ButtonNavView.swift
//  SeeFood2
//
//  Created by Satria Dafa Putra Wardhana on 14/05/25.
//

import SwiftUI

struct ButtonNavView: View {
    @Binding var isMapActive: Bool
    @Binding var showNavigationButton: Bool

    var body: some View {
        NavigationLink(isActive: $isMapActive) {
            NavigationMapView()
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
            .padding()
            .onTapGesture {
                isMapActive = true
                showNavigationButton = false // Sembunyikan tombol saat diklik
            }
        }
    }
}
#Preview {
    @State var isMapActive = false 
    @State var showNavigationButton = true
    return ButtonNavView(isMapActive: $isMapActive, showNavigationButton: $showNavigationButton)
}
