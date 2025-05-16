import SwiftUI

struct MenuItem: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let description: String
    let price: String
    let category: String
    let location: String?

    var priceValue: Int? {
        return price.replacingOccurrences(of: "Rp ", with: "").replacingOccurrences(of: ".-", with: "").replacingOccurrences(of: ".", with: "").toInt()
    }
}

extension String {
    func toInt() -> Int? {
        return Int(self)
    }
}

let menuData: [String: [[String: String]]] = [
    "Makanan Berat": [
        [
            "name": "Nasi Uduk",
            "imageName": "MB-1",
            "description": "Nasi gurih beraroma serai dan santan. Bertabur bawang goreng.",
            "price": "Rp 15.000,-",
            "category": "Makanan Berat",
            "location": "GOP 9"
        ],
        [
            "name": "Nasi Ayam Madu",
            "imageName": "MB-2",
            "description": "Nasi hangat dengan ayam berlapis madu alami gurih.",
            "price": "Rp 45.000,-",
            "category": "Makanan Berat",
            "location": "Traveloka Campus"
        ],
        [
            "name": "Nasi Ayam Jeruk",
            "imageName": "MB-3",
            "description": "Nasi hangat dengan irisan jeruk segar menyegarkan.",
            "price": "Rp 40.000,-",
            "category": "Makanan Berat",
            "location": "GOP 6"
        ],
        [
            "name": "Rica-rica Ayam",
            "imageName": "MB-4",
            "description": "Ayam pedas bumbu rica-rica khas negara hangat.",
            "price": "Rp 35.000,-",
            "category": "Makanan Berat",
            "location": "GOP 9"
        ],
        [
            "name": "Nasi Ikan Tuna",
            "imageName": "MB-5",
            "description": "Nasi hangat dengan tuna bakar bumbu khas pulau.",
            "price": "Rp 50.000,-",
            "category": "Makanan Berat",
            "location": "Traveloka Campus"
        ],
        [
            "name": "Mie Laksa",
            "imageName": "MB-6",
            "description": "Mie kuah dengan sayur dan tahu serta rempah khas dari Singapura.",
            "price": "Rp 38.000,-",
            "category": "Makanan Berat",
            "location": "GOP 6"
        ],
        [
            "name": "Bubur India",
            "imageName": "H-1",
            "description": "Bubur hangat dengan irisan buah, kacang, dan santan.",
            "price": "Rp 28.000,-",
            "category": "Makanan Berat",
            "location": "GOP 9"
        ],
        [
            "name": "Menu Sarapan",
            "imageName": "H-3",
            "description": "Nasi hangat dengan telur mata sapi.",
            "price": "Rp 22.000,-",
            "category": "Makanan Berat",
            "location": "Traveloka Campus"
        ],
        [
            "name": "Steak",
            "imageName": "H-5",
            "description": "Daging panggang dengan tambahan saus dan irisan sayuran.",
            "price": "Rp 60.000,-",
            "category": "Makanan Berat",
            "location": "GOP 6"
        ]
    ],
    "Makanan Ringan": [
        [
            "name": "Salad Sayur",
            "imageName": "MR-1",
            "description": "Campuran sayuran segar, dan keju dengan mayones yang bervariasi.",
            "price": "Rp 30.000,-",
            "category": "Makanan Ringan",
            "location": "GOP 9"
        ],
        [
            "name": "Pizza",
            "imageName": "MR-2",
            "description": "Pizza dengan pilihan isian dari daging, sayur, dan keju.",
            "price": "Rp 35.000,-",
            "category": "Makanan Ringan",
            "location": "Traveloka Campus"
        ],
        [
            "name": "Roti Isi",
            "imageName": "MR-3",
            "description": "Roti gandum dengan isian sayur, buah, daging, telur yang bergizi.",
            "price": "Rp 25.000,-",
            "category": "Makanan Ringan",
            "location": "GOP 6"
        ],
        [
            "name": "Keripik Ikan",
            "imageName": "MR-4",
            "description": "Keripik ikan tenggiri yang kaya gizi dengan pilihan rasa beragam.",
            "price": "Rp 18.000,-",
            "category": "Makanan Ringan",
            "location": "GOP 9"
        ],
        [
            "name": "Makaroni",
            "imageName": "MR-5",
            "description": "Makaroni dengan bumbu keju khas dan sayur yang gurih.",
            "price": "Rp 20.000,-",
            "category": "Makanan Ringan",
            "location": "Traveloka Campus"
        ],
        [
            "name": "Sosis Panggang",
            "imageName": "MR-6",
            "description": "Sosis panggang dengan saus tomat dan sayur.",
            "price": "Rp 28.000,-",
            "category": "Makanan Ringan",
            "location": "GOP 6"
        ],
        [
            "name": "Kentang Goreng",
            "imageName": "H-2",
            "description": "Kentang goreng renyah dengan mayones dan saus panggang.",
            "price": "Rp 15.000,-",
            "category": "Makanan Ringan",
            "location": "GOP 9"
        ],
        [
            "name": "Panekuk",
            "imageName": "H-4",
            "description": "Panekuk dengan taburan kacang dan krim susu.",
            "price": "Rp 38.000,-",
            "category": "Makanan Ringan",
            "location": "Traveloka Campus"
        ],
        [
            "name": "Smoothies",
            "imageName": "H-6",
            "description": "Campuran buah yang dihaluskan dengan taburan buah potong.",
            "price": "Rp 37.000,-",
            "category": "Makanan Ringan",
            "location": "GOP 6"
        ]
    ],
    "Minuman": [
        [
            "name": "Es Kelapa",
            "imageName": "M-1",
            "description": "Es kelapa dingin berisi serutan buah kelapa yang segar.",
            "price": "Rp 22.000,-",
            "category": "Minuman",
            "location": "GOP 9"
        ],
        [
            "name": "Es Teh",
            "imageName": "M-2",
            "description": "Es teh dingin dari Suko yang memiliki rasa khas.",
            "price": "Rp 8.000,-",
            "category": "Minuman",
            "location": "Traveloka Campus"
        ],
        [
            "name": "Jus Semangka",
            "imageName": "M-3",
            "description": "Jus semangka hasil panen petani lokal.",
            "price": "Rp 12.000,-",
            "category": "Minuman",
            "location": "GOP 6"
        ],
        [
            "name": "Air Infus",
            "imageName": "M-4",
            "description": "Air mineral dingin dengan irisan buah jeruk nipis atau mentimun.",
            "price": "Rp 15.000,-",
            "category": "Minuman",
            "location": "GOP 9"
        ],
        [
            "name": "Jus Wortel",
            "imageName": "M-5",
            "description": "Jus wortel dengan campuran sedikit nanas segar.",
            "price": "Rp 18.000,-",
            "category": "Minuman",
            "location": "Traveloka Campus"
        ],
        [
            "name": "Soda Gembira",
            "imageName": "M-6",
            "description": "Es soda dingin dengan sirup perasa buah yang segar.",
            "price": "Rp 20.000,-",
            "category": "Minuman",
            "location": "GOP 6"
        ]
    ],
    "Pasti Halal": [
        [
            "name": "Nasi Uduk (Halal)",
            "imageName": "MB-1",
            "description": "Nasi gurih beraroma serai dan santan. Bertabur bawang goreng.",
            "price": "Rp 15.000,-",
            "category": "Pasti Halal",
            "location": "GOP 9"
        ],
        [
            "name": "Salad Sayur (Halal)",
            "imageName": "MR-1",
            "description": "Campuran sayuran segar, dan keju dengan mayones yang bervariasi.",
            "price": "Rp 30.000,-",
            "category": "Pasti Halal",
            "location": "GOP 6"
        ],
        [
            "name": "Es Kelapa (Halal)",
            "imageName": "M-1",
            "description": "Es kelapa dingin berisi serutan buah kelapa yang segar.",
            "price": "Rp 22.000,-",
            "category": "Pasti Halal",
            "location": "GOP 9"
        ]
        // Tambahkan item lain yang pasti halal di sini dengan lokasi
    ]
]

extension MenuItem {
    static let all: [MenuItem] = {
        var items: [MenuItem] = []
        for (_, categoryItems) in menuData {
            for item in categoryItems {
                if let name = item["name"],
                   let imageName = item["imageName"],
                   let description = item["description"],
                   let price = item["price"],
                   let category = item["category"],
                   let location = item["location"] { // Ambil nilai lokasi
                    let menuItem = MenuItem(name: name, imageName: imageName, description: description, price: price, category: category, location: location) // Sertakan lokasi
                    items.append(menuItem)
                }
            }
        }
        return items
    }()
}
