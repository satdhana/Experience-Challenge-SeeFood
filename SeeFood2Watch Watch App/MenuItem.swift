import Foundation // Cukup Foundation karena tidak ada View di sini

// MARK: - 1. Definisi MenuItem
struct MenuItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let price: String
    // Untuk kesederhanaan, kita bisa hilangkan category dan location di awal
    // agar data lebih flat dan mudah dicheck compiler.
    // Jika perlu, tambahkan kembali nanti.
}

// MARK: - 2. Data Menu Sederhana
// Data langsung dalam bentuk array MenuItem, jauh lebih mudah bagi compiler
let simpleMenuItems: [MenuItem] = [
    MenuItem(name: "Nasi Goreng", description: "Nasi yang digoreng", price: "Rp 25.000"),
    MenuItem(name: "Mie Ayam", description: "Mie dengan topping ayam", price: "Rp 20.000"),
    MenuItem(name: "Bakso", description: "Bakso kuah", price: "Rp 18.000"),
    MenuItem(name: "Sate Ayam", description: "Sate ayam dengan bumbu kacang", price: "Rp 30.000"),
    MenuItem(name: "Sop Buntut", description: "Sop dari buntut sapi", price: "Rp 45.000"),
    MenuItem(name: "Gado-Gado", description: "Salad Indonesia dengan saus kacang", price: "Rp 22.000")
]

// MARK: - 3. Ekstensi MenuItem untuk 'all'
extension MenuItem {
    static let all: [MenuItem] = simpleMenuItems.shuffled() // Cukup ambil dari simpleMenuItems
}
