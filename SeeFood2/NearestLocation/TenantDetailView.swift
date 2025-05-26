//
//  TenantDetailView.swift
//  SeeFood2
//
//  Created by Satria Dafa Putra Wardhana on 15/05/25.
//

import SwiftUI

struct TenantDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    
    
    struct MenuItem: Identifiable {
        let id = UUID()
        let imageName: String
        let name: String
        let location: String // Bisa digunakan untuk mengidentifikasi tenant
        let description: String
        let price: String
        let category: String // Tambahkan properti category
    }

    let menuItems: [MenuItem] = [
        MenuItem(imageName: "nasiuduk", name: "Nasi Uduk", location: "Mama Jempol", description: "Nasi gurih beraroma serai dan salam, bertabur bawang goreng", price: "Rp 35.000,-", category: "Makanan Utama"),
        MenuItem(imageName: "pizza", name: "Pizza", location: "Uena", description: "Pizza dengan pilihan isian dari daging, sayur, dan keju", price: "Rp 35.000,-", category: "Makanan Utama"),
        MenuItem(imageName: "eskelapa", name: "Es Kelapa", location: "Mama Jempol", description: "Es kelapa dengan variasi perasa buah yang segar", price: "Rp 27.000,-", category: "Minuman"),
        MenuItem(imageName: "makaroni", name: "Makaroni", location: "Uena", description: "Makaroni dengan bumbu khas dari Italia yang gurih", price: "Rp 39.000,-", category: "Makanan Utama"),
        
    ]
    
    let tenant: NearestPlaceData

    var tenantMenuItems: [MenuItem] {
        menuItems.filter { $0.location == tenant.title }
    }

    var body: some View {
            VStack(spacing: 0) {
                // Header
                ZStack {
                    Image("Background")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 110)
                        .ignoresSafeArea()

                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Button { 
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Text(tenant.title)
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

                // Konten di bawah Header
                VStack(alignment: .leading) {
                    HStack(spacing: 16) {
                        Image(tenant.imageName) // Logo Tenant
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .cornerRadius(8)

                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "mappin.fill")
                                    .foregroundColor(.green)
                                Text(tenant.location)
                                    .foregroundColor(.secondary)
                            }
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(.green)
                                Text(tenant.openHours)
                                    .foregroundColor(.secondary)
                            }
                            HStack {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.green)
                                Text(tenant.phoneNumber)
                                    .foregroundColor(.secondary)
                            }
                            HStack {
                                Image(systemName: "tag.fill")
                                    .foregroundColor(.green)
                                Text(tenant.priceRange)
                                    .foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                    }
                    .padding()

                    Divider()
                    
                    ScrollView {
                        // Menu
                        Text("Menu")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        VStack(spacing: 16) {
                            ForEach(tenantMenuItems) { menuItem in
                                HStack(spacing: 16) {
                                    Image(menuItem.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(8)

                                    VStack(alignment: .leading) {
                                        Text(menuItem.name)
                                            .font(.headline)
                                        HStack {
                                            Image(systemName: "mappin.fill")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                            Text(menuItem.location)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        Text(menuItem.description)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text(menuItem.price)
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                    }
                                    Spacer()
                                    Image(systemName: "star") // Placeholder untuk ikon favorite
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal)
                                .padding(.bottom)
                                .background(Color.white) // Optional: Add background to each menu item
                                .cornerRadius(10) // Optional: Add rounded corners
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2) // Optional: Add shadow
                            }
                        }
                        .padding(.bottom) // Add padding at the end of the scroll view
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .navigationBarHidden(true)
            .ignoresSafeArea(.all)
    }
}

struct TenantDetailView_Previews: PreviewProvider {
    static let dummyTenant = NearestPlaceData(imageName: "M", title: "Mama Jempol", location: "GOP 9 | 50m", distanceInMeters: 50, openHours: "09:00 - 14:00", phoneNumber: "+62...", priceRange: "Rp 15.000 - Rp 55.000")

    static var previews: some View {
        NavigationView {
            TenantDetailView(tenant: dummyTenant)
        }
    }
}

