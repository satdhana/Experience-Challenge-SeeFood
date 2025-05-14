import SwiftUI

struct FilterSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var internalSelectedCategory: String? // Gunakan @State
    @State private var internalSelectedPriceRange: String? // Gunakan @State

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Filter")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.horizontal)

                Divider()

                // Location Filters
                Text("Lokasi")
                    .font(.headline)
                    .padding(.top)
                    .padding(.horizontal)

                ScrollView(.horizontal) {
                    HStack {
                        FilterButton(title: "All", isSelected: internalSelectedCategory == "All") // Gunakan state internal
                            .onTapGesture { internalSelectedCategory = "All" }
                        FilterButton(title: "GOP 9", isSelected: internalSelectedCategory == "GOP 9")
                            .onTapGesture { internalSelectedCategory = "GOP 9" }
                        // ... tombol lokasi lainnya ...
                    }
                    .padding(.horizontal)
                }

                // Price Range Filters
                Text("Opsi Harga")
                    .font(.headline)
                    .padding(.top)
                    .padding(.horizontal)

                ScrollView(.horizontal) {
                    HStack {
                        FilterButton(title: "Under 20K", isSelected: internalSelectedPriceRange == "Under 20K") // Gunakan state internal
                            .onTapGesture { internalSelectedPriceRange = "Under 20K" }
                        FilterButton(title: "Under 50K", isSelected: internalSelectedPriceRange == "Under 50K")
                            .onTapGesture { internalSelectedPriceRange = "Under 50K" }
                        // ... tombol harga lainnya ...
                    }
                    .padding(.horizontal)
                }

                // Operational Hour Filters
                Text("Jam Operasional")
                    .font(.headline)
                    .padding(.top)
                    .padding(.horizontal)

                ScrollView(.horizontal) {
                    HStack {
                        FilterButton(title: "24 Hours", isSelected: false) // Contoh tanpa state
                        // ... tombol jam lainnya ...
                    }
                    .padding(.horizontal)
                }

                Spacer()

                Button {
                    print("See the Results tapped with category: \(internalSelectedCategory ?? "None"), price: \(internalSelectedPriceRange ?? "None")")
                    dismiss() // Close the sheet
                    // Di sini Anda bisa mengirimkan nilai filter internal ke ContentView jika diperlukan
                } label: {
                    HStack {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
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
                        internalSelectedCategory = nil // Reset state internal
                        internalSelectedPriceRange = nil // Reset state internal
                        print("Reset filters")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        print("Apply filters with category: \(internalSelectedCategory ?? "None"), price: \(internalSelectedPriceRange ?? "None")")
                        dismiss() // Close the sheet
                        // Di sini Anda bisa mengirimkan nilai filter internal ke ContentView jika diperlukan
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
    FilterSheetView() // Tidak perlu binding di preview karena menggunakan @State
}
