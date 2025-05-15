import SwiftUI
import MapKit

struct ContentView: View {
    // MARK: - State Properties

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
    @State private var showNavigationButton = false
    @State private var selectedMenuItem: MenuItem?
    @State private var isMapActive = false

    // MARK: - Computed Properties

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
                    case "Di Bawah 20K": return price < 20000
                    case "Di Bawah 50K": return price < 50000
                    case "Di Bawah 100K": return price < 100000
                    default: return true
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

    @ViewBuilder
    private var searchResultsView: some View {
        if !recentSearches.isEmpty && searchText.isEmpty {
            RecentSearchesView(recentSearches: $recentSearches, searchText: $searchText)
        } else if filteredAndCategorizedMenu.isEmpty && !searchText.isEmpty {
            NoSearchResultsView(searchText: searchText, randomRecommendations: randomRecommendations, showNavigationButton: $showNavigationButton, selectedMenuItem: $selectedMenuItem, generateRandomRecommendations: generateRandomRecommendations)
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
                showNavigationButton: $showNavigationButton,
                selectedMenuItem: $selectedMenuItem
            )
            .padding(.top, -130)
            .transition(.move(edge: .top))
        }
    }

    @ViewBuilder
        private var mainContentView: some View {
            if isCategoryListVisible {
                MenuList(
                    menuItems: filteredAndCategorizedMenu,
                    categoryTitle: selectedCategory ?? "Semua Menu",
                    showNavigationButton: $showNavigationButton,
                    selectedMenuItem: $selectedMenuItem
                )
                .padding(.top, -25)
                .padding(.top, 20)
            } else {
                VStack {
                    RecommendationCarouselView()
                        .padding(.top, 20)
                    NearestHereCarouselView()
                        .padding(.top, 20)
                    YourFavoritesView(showNavigationButton: .constant(true))
                }
            }
        }

    // MARK: - Helper Functions

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

    // MARK: - View Body

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    VStack(alignment: .leading) {
                        HeaderView(
                            searchText: $searchText,
                            selectedCategory: $selectedCategory,
                            searchFieldFocused: _searchFieldFocused,
                            recentSearches: $recentSearches,
                            isFilterSheetPresented: $isFilterSheetPresented
                        )

                        ScrollView {
                            VStack(alignment: .leading) {
                                CategoryButtonView(
                                    selectedCategory: $selectedCategory,
                                    categories: categories,
                                    isCategoryListVisible: $isCategoryListVisible
                                )
                                .padding(.top, 20)
                                .opacity(searchFieldFocused ? 0 : 1)
                                .animation(.easeInOut(duration: 0.2), value: searchFieldFocused)
                            }

                            if searchFieldFocused {
                                searchResultsView
                            } else {
                                mainContentView
                            }
                        }
                        .padding(.top, 20)
                    }
                    .padding(.top, -20)
                }
                .onTapGesture {
                    searchFieldFocused = false
                    if isCategoryListVisible {
                        isCategoryListVisible = false
                        selectedCategory = nil
                    }
                }
                .onChange(of: searchFieldFocused) { _, newValue in
                    if newValue {
                        if searchText.isEmpty {
                            generateRandomRecommendations()
                        }
                    } else {
                        randomRecommendations = []
                        showNoResultsAlert = false
                    }
                }
                .onChange(of: searchText) { _, _ in
                    randomRecommendations = []
                }
                .onChange(of: selectedCategory) { _, _ in
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

                if showNavigationButton {
                    VStack {
                        Spacer()
                        ButtonNavView(isMapActive: $isMapActive, showNavigationButton: $showNavigationButton)
                    }
                    .zIndex(1)
                }
                
            }
            .navigationBarHidden(true)
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

// MARK: - Subviews

struct RecentSearchesView: View {
    @Binding var recentSearches: [String]
    @Binding var searchText: String

    var body: some View {
        VStack(alignment: .leading) {
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
        }
    }
}

struct NoSearchResultsView: View {
    let searchText: String
    let randomRecommendations: [MenuItem]
    @Binding var showNavigationButton: Bool
    @Binding var selectedMenuItem: MenuItem?
    let generateRandomRecommendations: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text("Maaf, kami tidak menemukan \"\(searchText)\"")
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.top)

            if !randomRecommendations.isEmpty {
                MenuList(
                    menuItems: randomRecommendations,
                    categoryTitle: "Mungkin Anda Suka",
                    showNavigationButton: $showNavigationButton,
                    selectedMenuItem: $selectedMenuItem
                )
                .padding(.top)
            } else {
                Text("Mencari rekomendasi...")
                    .foregroundColor(.gray)
                    .padding(.top)
            }
        }
    }
}

#Preview {
    ContentView()
}
