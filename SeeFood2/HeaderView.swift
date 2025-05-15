import SwiftUI

struct HeaderView: View {
    @Binding var searchText: String
    @Binding var selectedCategory: String?
    @FocusState var searchFieldFocused: Bool
    @Binding var recentSearches: [String]
    @Binding var isFilterSheetPresented: Bool
    @StateObject var locationManager = LocationManagers()
    
    func addRecentSearch(_ query: String) {
        if let index = recentSearches.firstIndex(of: query) {
            recentSearches.remove(at: index)
        }
        recentSearches.insert(query, at: 0)
        if recentSearches.count > 10 {
            recentSearches.removeLast()
        }
    }
    
    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(
                    VStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.black)
                                VStack(alignment: .leading) {
                                    Text("Lokasi Sekarang")
                                        .font(.caption)
                                        .foregroundColor(.black.opacity(0.8))
                                    Text("Jl. Raya Seribu Angka Raya No. 123, BSD, ... ")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                .padding(.leading, 4)
                            }
                            .padding(6)
                            .padding(.leading, 8)
                            .background(Color(.white).opacity(0.5))
                            .cornerRadius(8)
                            .frame(maxWidth: .infinity)
                        }
                        
                        HStack {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                TextField("Mau Coba Chicken Teriyaki?", text: $searchText)
                                    .focused($searchFieldFocused)
                                    .onSubmit {
                                        if !searchText.isEmpty {
                                            addRecentSearch(searchText)
                                        }
                                    }
                                    .onTapGesture {
                                        searchFieldFocused = true
                                    }
                            }
                            .padding(12)
                            .background(Color(.white))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .frame(maxWidth: .infinity)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
                            // Kondisi untuk menampilkan tombol filter
                            if searchFieldFocused {
                                Button {
                                    isFilterSheetPresented = true
                                } label: {
                                    Image(systemName: "slider.horizontal.3")
                                        .font(.title2)
                                        .foregroundColor(.gray)
                                        .padding(8)
                                }
                                .frame(width: 44, height: 44, alignment: .center)
                                .background(Color(.white))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
                            }
                            
                            
                        }
                        .padding(.horizontal, 24)
                        
                        Spacer()
                    }
                        .padding(.top, 120)
                )
        }
        .frame(height: 120)
        .ignoresSafeArea(.all)
        .padding(.bottom, -20)
        .onAppear {
                    locationManager.startUpdatingLocation()
                }
    }
}

#Preview {
    @State var previewSearchText = ""
    @State var previewSelectedCategory: String? = nil
    @FocusState var previewSearchFieldFocused: Bool
    @State var previewRecentSearches: [String] = []
    @State var previewIsFilterSheetPresented = false // Tambahkan state untuk isFilterSheetPresented
    
    return HeaderView(
        searchText: $previewSearchText,
        selectedCategory: $previewSelectedCategory,
        searchFieldFocused: _previewSearchFieldFocused,
        recentSearches: $previewRecentSearches,
        isFilterSheetPresented: $previewIsFilterSheetPresented
    )
}
