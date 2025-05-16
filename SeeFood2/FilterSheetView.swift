import SwiftUI

struct FilterSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCategory: String?
    @Binding var selectedPriceRange: String?
    @Binding var selectedLocation: String?
    @Binding var isFilterActive: Bool

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Filter")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.horizontal)

                Divider()

                Text("Lokasi")
                    .font(.headline)
                    .padding(.top)
                    .padding(.horizontal)

                ScrollView(.horizontal) {
                    HStack {
                        FilterButton(title: "All", isSelected: selectedLocation == "All")
                            .onTapGesture { selectedLocation = "All" }
                        FilterButton(title: "GOP 9", isSelected: selectedLocation == "GOP 9")
                            .onTapGesture { selectedLocation = "GOP 9" }
                        FilterButton(title: "GOP 6", isSelected: selectedLocation == "GOP 6")
                            .onTapGesture { selectedLocation = "GOP 6" }
                        FilterButton(title: "Traveloka Campus", isSelected: selectedLocation == "Traveloka Campus")
                            .onTapGesture { selectedLocation = "Traveloka Campus" }
                    }
                    .padding(.horizontal)
                }

                Text("Opsi Harga")
                    .font(.headline)
                    .padding(.top)
                    .padding(.horizontal)

                ScrollView(.horizontal) {
                    HStack {
                        FilterButton(title: "Di Bawah 20K", isSelected: selectedPriceRange == "Di Bawah 20K")
                            .onTapGesture { selectedPriceRange = "Di Bawah 20K" }
                        FilterButton(title: "Di Bawah 50K", isSelected: selectedPriceRange == "Di Bawah 50K")
                            .onTapGesture { selectedPriceRange = "Di Bawah 50K" }
                        FilterButton(title: "Di Bawah 100K", isSelected: selectedPriceRange == "Di Bawah 100K")
                            .onTapGesture { selectedPriceRange = "Di Bawah 100K" }
                    }
                    .padding(.horizontal)
                }

                Text("Jam Operasional")
                    .font(.headline)
                    .padding(.top)
                    .padding(.horizontal)

                ScrollView(.horizontal) {
                    HStack {
                        FilterButton(title: "24 Jam", isSelected: false) // Anda perlu binding untuk ini jika ingin berfungsi
                        FilterButton(title: "Dari 9 sampai 5", isSelected: false) // Anda perlu binding untuk ini jika ingin berfungsi
                        FilterButton(title: "Dari 10 sampai 11", isSelected: false) // Anda perlu binding untuk ini jika ingin berfungsi
                    }
                    .padding(.horizontal)
                }

                Spacer()

                Button {
                    isFilterActive = selectedCategory != nil || selectedPriceRange != nil || selectedLocation != nil
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        Text("Lihat Hasil")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedCategory != nil || selectedPriceRange != nil || selectedLocation != nil ? Color.orange : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        selectedCategory = nil
                        selectedPriceRange = nil
                        selectedLocation = nil
                        isFilterActive = false
                    }
                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Apply") {
//                        isFilterActive = selectedCategory != nil || selectedPriceRange != nil || selectedLocation != nil
//                        dismiss()
//                    }
//                }
            }
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        Text(title)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.orange.opacity(0.8) : Color.gray.opacity(0.2))
            .foregroundColor(isSelected ? .white : .black)
            .cornerRadius(8)
            .font(.caption)
    }
}

#Preview {
    @State var previewSelectedCategory: String? = nil
    @State var previewSelectedPriceRange: String? = nil
    @State var previewSelectedLocation: String? = nil
    @State var previewIsFilterActive = false

    return FilterSheetView(
        selectedCategory: $previewSelectedCategory,
        selectedPriceRange: $previewSelectedPriceRange,
        selectedLocation: $previewSelectedLocation,
        isFilterActive: $previewIsFilterActive
    )
}
