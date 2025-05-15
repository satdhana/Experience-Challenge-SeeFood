import SwiftUI
import MapKit

struct MenuList: View {
    let menuItems: [MenuItem]
    let categoryTitle: String

//    @State private var showNavigationButton = false
    @State private var navigateToMap = false
    
    @Binding var showNavigationButton: Bool // Binding dari ContentView
    @Binding var selectedMenuItem: MenuItem?

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
                                if let location = item.location {
                                    Text("Lokasi: \(location)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Text(item.price)
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showNavigationButton = true
                                        selectedMenuItem = item // Atau onMenuItemTap(item) jika menggunakan callback
                                    }
                                }
                    }
                }
                .padding(.vertical)
            }

            
        }
        .padding(.top)
    }
}


#Preview {
    let sampleCategory = "Makanan Berat"
    let sampleMenuItems = MenuItem.all.filter { $0.category == sampleCategory }
    @State var showButton = false // Membuat state untuk binding
    @State var selectedItem: MenuItem? // Membuat state untuk binding
    return MenuList(
        menuItems: sampleMenuItems,
        categoryTitle: sampleCategory,
        showNavigationButton: $showButton,
        selectedMenuItem: $selectedItem
    )
}
