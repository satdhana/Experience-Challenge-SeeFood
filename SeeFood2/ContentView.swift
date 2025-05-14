import SwiftUI
import MapKit

struct ContentView: View {
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil
    @FocusState private var searchFieldFocused: Bool
    @State private var randomRecommendations: [MenuItem] = []
    @State private var showNoResultsAlert = false
    @State private var isCategoryListVisible: Bool = false
    @State private var recentSearches: [String] = []
    @State private var isFilterSheetPresented: Bool = false
    @State private var selectedPriceRange: String? = nil
    @State private var selectedLocation: String? = nil
    @State private var showNavigationButton = false // State dipindahkan ke ContentView
    @State private var selectedMenuItem: MenuItem? // State dipindahkan ke ContentView

    func addRecentSearch(_ query: String) {
        if let index = recentSearches.firstIndex(of: query) {
            recentSearches.remove(at: index)
        }
        recentSearches.insert(query, at: 0)
        if recentSearches.count > 10 {
            recentSearches.removeLast()
        }
    }

    func generateRandomRecommendations(count: Int = 3) {
        guard !MenuItem.all.isEmpty else {
            randomRecommendations = []
            return
        }
        let shuffled = MenuItem.all.shuffled()
        randomRecommendations = Array(shuffled.prefix(min(count, MenuItem.all.count)))
    }

    let categories: [String] = ["Semua Menu", "Makanan Berat", "Makanan Ringan", "Minuman", "Pasti Halal"]

    var filteredAndCategorizedMenu: [MenuItem] {
        var filtered = MenuItem.all

        if let category = selectedCategory, category != "Semua Menu" {
            filtered = filtered.filter { $0.category == category }
        }

        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }

        if let priceRange = selectedPriceRange {
            filtered = filtered.filter { item in
                if let price = item.priceValue {
                    switch priceRange {
                    case "Di Bawah 20K":
                        return price < 20000
                    case "Di Bawah 50K":
                        return price < 50000
                    case "Di Bawah 100K":
                        return price < 100000
                    default:
                        return true
                    }
                } else {
                    return true
                }
            }
        }

        if let location = selectedLocation, location != "All" {
            filtered = filtered.filter { $0.location == location }
        }

        return filtered
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) { // ZStack untuk efek mengambang
                VStack(spacing: 0) { // VStack utama untuk HeaderView dan ScrollView
                    VStack(alignment: .leading) { // VStack untuk HeaderView agar tetap di atas
                        HeaderView(
                            searchText: $searchText,
                            selectedCategory: $selectedCategory,
                            searchFieldFocused: _searchFieldFocused,
                            recentSearches: $recentSearches,
                            isFilterSheetPresented: $isFilterSheetPresented
                        )

                    ScrollView {
                        VStack(alignment: .leading) {
                            CategoryButtonView(selectedCategory: $selectedCategory, categories: categories, isCategoryListVisible: $isCategoryListVisible)
                                .padding(.top, 20)
                                .opacity(searchFieldFocused ? 0 : 1)
                                .animation(.easeInOut(duration: 0.2), value: searchFieldFocused)
                        }
                            if searchFieldFocused {
                                VStack(alignment: .leading) {
                                    if !recentSearches.isEmpty && searchText.isEmpty {
                                        Text("Pencarian Terakhir")
                                            .font(.headline)
                                            .padding(.horizontal)
                                            .padding(.top)
                                        ForEach(recentSearches, id: \.self) { query in
                                            Button {
                                                searchText = query
                                            } label: {
                                                HStack {
                                                    Image(systemName: "clock.fill")
                                                        .foregroundColor(.gray)
                                                    Text(query)
                                                        .foregroundColor(.primary)
                                                    Spacer()
                                                    Image(systemName: "xmark")
                                                        .foregroundColor(.gray)
                                                        .onTapGesture {
                                                            if let index = recentSearches.firstIndex(of: query) {
                                                                recentSearches.remove(at: index)
                                                            }
                                                        }
                                                }
                                                .padding(.horizontal)
                                                .padding(.vertical, 4)
                                            }
                                        }
                                    } else if filteredAndCategorizedMenu.isEmpty && !searchText.isEmpty {
                                        VStack(alignment: .leading) {
                                            Text("Maaf, kami tidak menemukan \"\(searchText)\"")
                                                .foregroundColor(.gray)
                                                .padding(.horizontal)
                                                .padding(.top)

                                            if !randomRecommendations.isEmpty {
                                                MenuList(
                                                    menuItems: randomRecommendations,
                                                    categoryTitle: "Mungkin Anda Suka",
                                                    showNavigationButton: $showNavigationButton, // Binding
                                                    selectedMenuItem: $selectedMenuItem // Binding
                                                )
                                                .padding(.top)
                                            } else {
                                                Text("Mencari rekomendasi...")
                                                    .foregroundColor(.gray)
                                                    .padding(.top)
                                            }
                                        }
                                        .padding(.top, -90)
                                        .onAppear {
                                            if randomRecommendations.isEmpty {
                                                generateRandomRecommendations(count: Int.random(in: 3...5))
                                            }
                                        }
                                    } else {
                                        MenuList(
                                            menuItems: filteredAndCategorizedMenu,
                                            categoryTitle: "Hasil Pencarian",
                                            showNavigationButton: $showNavigationButton, // Binding
                                            selectedMenuItem: $selectedMenuItem // Binding
                                        )
                                        .padding(.top, -130)
                                        .transition(.move(edge: .top))
                                    }
                                }
                            } else {
                                if isCategoryListVisible {
                                    MenuList(
                                        menuItems: filteredAndCategorizedMenu,
                                        categoryTitle: selectedCategory ?? "Semua Menu",
                                        showNavigationButton: $showNavigationButton, // Binding
                                        selectedMenuItem: $selectedMenuItem // Binding
                                    )
                                    .padding(.top, 20)
                                    .padding(.top, 20)
                                } else {
                                    VStack {
                                        RecommendationCarouselView()
                                            .padding(.top, 20)
                                        NearestHereCarouselView()
                                            .padding(.top, 20)
                                        YourFavoritesView()
                                    }
                                }
                            }
                        }
                        .padding(.top, 20) // Padding untuk konten scroll
                    }
                    .padding(.top, -20) // Mengatasi overlap dengan HeaderView
                }
                .onTapGesture {
                    searchFieldFocused = false
                    if isCategoryListVisible {
                        isCategoryListVisible = false
                        selectedCategory = nil
                    }
                }
                .onChange(of: searchFieldFocused) { oldValue, newValue in
                    if newValue {
                        if searchText.isEmpty {
                            generateRandomRecommendations()
                        }
                    } else {
                        randomRecommendations = []
                        showNoResultsAlert = false
                    }
                }
                .onChange(of: searchText) { oldValue, newValue in
                    randomRecommendations = []
                }
                .onChange(of: selectedCategory) { oldValue, newValue in
                    searchFieldFocused = false
                    searchText = ""
                }
                .sheet(isPresented: $isFilterSheetPresented) {
                    FilterSheetView(
                        selectedCategory: $selectedCategory,
                        selectedPriceRange: $selectedPriceRange,
                        selectedLocation: $selectedLocation
                    )
                }

                // Button navigasi yang mengambang
                if showNavigationButton, let selectedItem = selectedMenuItem {
                    VStack {
                        Spacer()
                        NavigationLink(
                            destination: NavigationMapView(),
                            isActive: $showNavigationButton
                        ) {
                            EmptyView()
                        }

                        Button {
                            print("Let's Go for \(selectedItem.name)")
                            showNavigationButton = true // Atau atur state navigasi
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
                        .transition(.move(edge: .bottom))
                        .padding(.bottom)
                        .padding(.horizontal)
                    }
                    .zIndex(1)
                }
            }
            .navigationBarHidden(true)
            .ignoresSafeArea(.keyboard, edges: .bottom) // Agar button tidak tertutup keyboard
        }
    }
}

#Preview {
    ContentView()
}
