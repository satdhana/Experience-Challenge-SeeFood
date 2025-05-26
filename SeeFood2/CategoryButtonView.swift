import SwiftUI

struct MenuCategoryItem: View {
    let title: String
    let imageName: String // Nama aset gambar di Assets
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .padding(6)
                .frame(width: 75, height: 75)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.orange : Color.gray.opacity(0.2), lineWidth: 1) // Warna border berubah
                )
                .background(Color(.white).cornerRadius(8))
                .shadow(color: Color.black.opacity(0.1), radius: 6, x: 2, y: 4)
            
            Text(title)
                .font(.system(size: isSelected ? 10 : 9))
                .foregroundColor(isSelected ? .orange : .black)
                .fontWeight(isSelected ? .bold : .light)
        }
        .frame(width: 80, height: 100)
    }
}

struct CategoryButtonView: View {
    @Binding var selectedCategory: String? // Ubah menjadi opsional
    let categories: [String]
    @Binding var isCategoryListVisible: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(categories, id: \.self) { category in
                    Button {
                        if selectedCategory == category && isCategoryListVisible {
                            // Jika kategori yang diklik sama dengan yang sedang aktif dan menu list terlihat,
                            // maka sembunyikan menu list dan reset selectedCategory
                            selectedCategory = ""
                            isCategoryListVisible = false
                        } else {
                            // Jika kategori berbeda atau menu list tidak terlihat,
                            // maka pilih kategori dan tampilkan menu list
                            selectedCategory = category
                            isCategoryListVisible = true
                        }
                    } label: {
                        MenuCategoryItem(
                            title: category == "Semua Menu" ? "Semua Menu" : category, // Penyesuaian judul "Semua Menu"
                            imageName: getCategoryImage(category: category),
                            isSelected: selectedCategory == category
                        )
                    }
                }
            }
            .padding(.horizontal, 22)
        }
    }
    
    // Fungsi untuk mendapatkan nama gambar berdasarkan kategori
    func getCategoryImage(category: String) -> String {
        switch category {
        case "Makanan Berat":
            return "MakananBesar"
        case "Makanan Ringan":
            return "MakananRingan"
        case "Minuman":
            return "Minuman"
        case "Pasti Halal":
            return "PastiHalal"
        default:
            return "Logo" // Nama gambar default atau sesuaikan
        }
    }
}

#Preview {
    @State var previewCategory: String? = "Semua Menu"
    @State var previewIsCategoryListVisible: Bool = false
    let sampleCategories = ["Semua Menu", "Makanan Berat", "Makanan Ringan", "Minuman", "Pasti Halal"]
    CategoryButtonView(selectedCategory: $previewCategory, categories: sampleCategories, isCategoryListVisible: $previewIsCategoryListVisible)
}
