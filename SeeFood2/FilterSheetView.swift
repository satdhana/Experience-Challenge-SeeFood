import SwiftUI

struct FilterSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCategory: String?
    @Binding var selectedPriceRange: String?
    @Binding var selectedLocation: String?
    @State private var internalSelectedCategory: String?
    @State private var internalSelectedPriceRange: String?
    @State private var internalSelectedLocation: String?

    init(selectedCategory: Binding<String?>, selectedPriceRange: Binding<String?>, selectedLocation: Binding<String?>) {
        self._selectedCategory = selectedCategory
        self._selectedPriceRange = selectedPriceRange
        self._selectedLocation = selectedLocation
        _internalSelectedCategory = State(initialValue: selectedCategory.wrappedValue)
        _internalSelectedPriceRange = State(initialValue: selectedPriceRange.wrappedValue)
        _internalSelectedLocation = State(initialValue: selectedLocation.wrappedValue)
    }

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
                        FilterButton(title: "All", isSelected: internalSelectedLocation == "All")
                            .onTapGesture { internalSelectedLocation = "All" }
                        FilterButton(title: "GOP 9", isSelected: internalSelectedLocation == "GOP 9")
                            .onTapGesture { internalSelectedLocation = "GOP 9" }
                        FilterButton(title: "GOP 6", isSelected: internalSelectedLocation == "GOP 6")
                            .onTapGesture { internalSelectedLocation = "GOP 6" }
                        FilterButton(title: "Traveloka Campus", isSelected: internalSelectedLocation == "Traveloka Campus")
                            .onTapGesture { internalSelectedLocation = "Traveloka Campus" }
                    }
                    .padding(.horizontal)
                }

                Text("Opsi Harga")
                    .font(.headline)
                    .padding(.top)
                    .padding(.horizontal)

                ScrollView(.horizontal) {
                    HStack {
                        FilterButton(title: "Di Bawah 20K", isSelected: internalSelectedPriceRange == "Di Bawah 20K")
                            .onTapGesture { internalSelectedPriceRange = "Di Bawah 20K" }
                        FilterButton(title: "Di Bawah 50K", isSelected: internalSelectedPriceRange == "Di Bawah 50K")
                            .onTapGesture { internalSelectedPriceRange = "Di Bawah 50K" }
                        FilterButton(title: "Di Bawah 100K", isSelected: internalSelectedPriceRange == "Di Bawah 100K")
                            .onTapGesture { internalSelectedPriceRange = "Di Bawah 100K" }
                    }
                    .padding(.horizontal)
                }

                Text("Jam Operasional")
                    .font(.headline)
                    .padding(.top)
                    .padding(.horizontal)

                ScrollView(.horizontal) {
                    HStack {
                        FilterButton(title: "24 Jam", isSelected: false)
                        FilterButton(title: "Dari 9 sampai 5", isSelected: false)
                        FilterButton(title: "Dari 10 sampai 11", isSelected: false)
                    }
                    .padding(.horizontal)
                }

                Spacer()

                Button {
                    selectedCategory = internalSelectedCategory
                    selectedPriceRange = internalSelectedPriceRange
                    selectedLocation = internalSelectedLocation
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        Text("Lihat Hasil")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
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
                        internalSelectedCategory = nil
                        internalSelectedPriceRange = nil
                        internalSelectedLocation = nil
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        selectedCategory = internalSelectedCategory
                        selectedPriceRange = internalSelectedPriceRange
                        selectedLocation = internalSelectedLocation
                        dismiss()
                    }
                }
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

    return FilterSheetView(
        selectedCategory: $previewSelectedCategory,
        selectedPriceRange: $previewSelectedPriceRange,
        selectedLocation: $previewSelectedLocation
    )
}
