import SwiftUI

struct MenuList: View {
    let menuItems: [MenuItem]
    let categoryTitle: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(categoryTitle)
                .font(.headline)
                .padding(.horizontal)

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(menuItems) { item in
                        HStack {
                            Image(item.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)

                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.description)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(item.price)
                                    .font(.subheadline)
                                    .foregroundColor(.orange)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
        .padding(.top)
    }
}

#Preview {
    let sampleMenuItems = [
        MenuItem(name: "Nasi Uduk", imageName: "nasi_uduk", description: "Nasi gurih dengan...", price: "Rp 15.000", category: "Makanan Berat"),
        MenuItem(name: "Sate Ayam", imageName: "sate_ayam", description: "Sate ayam lezat...", price: "Rp 25.000", category: "Makanan Berat")
        // Tambahkan item menu lainnya sesuai kebutuhan
    ]
    return MenuList(menuItems: sampleMenuItems, categoryTitle: "Makanan Berat")
}
