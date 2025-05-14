import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil 
    @FocusState private var searchFieldFocused: Bool
    @State private var randomRecommendations: [MenuItem] = []
    @State private var showNoResultsAlert = false
    @State private var isCategoryListVisible: Bool = false
    @State private var recentSearches: [String] = []
    @State private var isFilterSheetPresented: Bool = false
    @State private var isFilterSheetVisible: Bool = false
    @State private var selectedPriceRange: String? = nil
    
    func addRecentSearch(_ query: String) {
            if let index = recentSearches.firstIndex(of: query) {
                recentSearches.remove(at: index) // Pindahkan ke atas jika sudah ada
            }
            recentSearches.insert(query, at: 0)
            if recentSearches.count > 10 {
                recentSearches.removeLast() // Batasi hingga 10 item
            }
        }
    
    func generateRandomRecommendations(count: Int) {
        guard !MenuItem.all.isEmpty else {
            randomRecommendations = []
            return
        }
        let shuffled = MenuItem.all.shuffled()
        randomRecommendations = Array(shuffled.prefix(min(count, MenuItem.all.count)))
    }
    
    let categories: [String] = ["Semua Menu", "Makanan Berat", "Makanan Ringan", "Minuman", "Pasti Halal"] // Kategori
    
    var filteredMenu: [MenuItem] {
        if searchText.isEmpty {
            return MenuItem.all
        } else {
            addRecentSearch(searchText) // Tambahkan ke recent searches
            return MenuItem.all.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var categorizedMenu: [MenuItem] {
        if selectedCategory == "Semua Menu" {
            return MenuItem.all
        } else {
            return MenuItem.all.filter { $0.category == selectedCategory }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .overlay(
                        VStack {
                            // Alamat
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "mappin.and.ellipse")
                                        .foregroundColor(.black)
                                    VStack(alignment: .leading) {
                                        Text("Lokasi Sekarang")
                                            .font(.caption)
                                            .foregroundColor(.black.opacity(0.8))
                                        Text("Jl. Pahlawan Seribu, Lengkong Karya, Kec...")
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
                            
                            // Search Bar
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
                                
                                if searchFieldFocused {
                                    Button {
                                        print("Filter button tapped")
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
                    .sheet(isPresented: $isFilterSheetPresented) {
                        FilterSheetView()
                    }
            }
            .frame(height: 120)
            .ignoresSafeArea(.all)
            
            ScrollView {
                CategoryButtonView(selectedCategory: $selectedCategory, categories: categories, isCategoryListVisible: $isCategoryListVisible)
                    .padding(.top, 20)
                    .opacity(searchFieldFocused ? 0 : 1)
                    .animation(.easeInOut(duration: 0.2), value: searchFieldFocused)

                if searchFieldFocused {
                    VStack(alignment: .leading) {
                        if !recentSearches.isEmpty && searchText.isEmpty {
                            Text("Recent Search")
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
                        } else if filteredMenu.isEmpty && !searchText.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Maaf, kami tidak menemukan \"\(searchText)\"")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                    .padding(.top)

                                if !randomRecommendations.isEmpty {
                                    MenuList(menuItems: randomRecommendations, categoryTitle: "Mungkin Anda Suka")
                                        .padding(.top)
                                } else {
                                    Text("Mencari rekomendasi...")
                                        .foregroundColor(.gray)
                                        .padding(.horizontal)
                                        .padding(.top)
                                }
                            }
                            .padding(.top, -90)
                            .onAppear {
                                if randomRecommendations.isEmpty {
                                    generateRandomRecommendations(count: Int.random(in: 3...5))
                                }
                            }
                        }else {
                            MenuList(menuItems: filteredMenu, categoryTitle: "Hasil Pencarian")
                                .padding(.top, -130)
                                .transition(.move(edge: .top))
                        }
                    }
                } else {
                    if isCategoryListVisible {
                        MenuList(menuItems: categorizedMenu, categoryTitle: selectedCategory ?? "Semua Menu")
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
            .padding(.top, -20)
            .onTapGesture {
                searchFieldFocused = false
                if isCategoryListVisible {
                    isCategoryListVisible = false
                    selectedCategory = ""
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
            }
            
        }
        
        func generateRandomRecommendations() {
            guard MenuItem.all.count >= 3 else {
                randomRecommendations = MenuItem.all.shuffled()
                return
            }
            let shuffled = MenuItem.all.shuffled()
            randomRecommendations = Array(shuffled.prefix(3))
        }
    }
    
    #Preview {
        ContentView()
    }
