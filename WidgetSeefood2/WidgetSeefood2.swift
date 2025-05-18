//
//  WidgetSeefood2.swift
//  WidgetSeefood2
//
//  Created by Satria Dafa Putra Wardhana on 16/05/25.
//

import WidgetKit
import SwiftUI
import AppIntents

struct RekomendasiItem: Identifiable {
    let id = UUID()
    let nama: String
    let lokasi: String
    let jarak: String
    let harga: String
    let imageName: String
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), rekomendasi: [
            RekomendasiItem(nama: "Mie Laksa", lokasi: "The Breeze", jarak: "500m", harga: "Rp 45 K", imageName: "MB-1"),
            RekomendasiItem(nama: "Es Kelapa", lokasi: "GOP 9", jarak: "900m", harga: "Rp 35 K", imageName: "M-1")
        ])
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), rekomendasi: [
            RekomendasiItem(nama: "Nasi Ayam", lokasi: "GOP 6", jarak: "300m", harga: "Rp 35 K", imageName: "MB-2"),
            RekomendasiItem(nama: "Jus Wortel", lokasi: "The Breeze", jarak: "500m", harga: "Rp 20 K", imageName: "M-5")
        ])
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        let rekomendasiData: [RekomendasiItem] = [
            RekomendasiItem(nama: "Nasi Ayam", lokasi: "GOP 6", jarak: "300m", harga: "Rp 35 K", imageName: "MB-2"),
            RekomendasiItem(nama: "Jus Wortel", lokasi: "The Breeze", jarak: "500m", harga: "Rp 20 K", imageName: "M-5")
        ]

        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, rekomendasi: rekomendasiData)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let rekomendasi: [RekomendasiItem]
}

struct RekomendasiCardView: View {
    let item: RekomendasiItem

    var body: some View {
        HStack(spacing : -6) {
            Image(item.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: .infinity)
                .clipped()
            VStack(alignment: .leading){
                Text(item.nama)
                    .font(.caption)
                    .fontWeight(.semibold)
                Text(item.lokasi)
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text(item.jarak)
                    .font(.caption2)
                    .foregroundColor(.gray)
                Spacer()
                Text(item.harga)
                    .font(.caption)
                    .foregroundColor(.green)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.vertical,4)
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct MediumWidgetView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "fork.knife")
                    .font(.title3)
                    .foregroundColor(.orange)
                VStack(alignment: .leading) {
                    
                    Text("Rekomendasi Hari Ini")
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("Yuk tentukan sebelum waktu makan")
                        .font(.footnote)
                        .foregroundColor(.black)
                        .padding(.bottom, 8)
                }
            
            }
            HStack {
                if entry.rekomendasi.count > 0 {
                    RekomendasiCardView(item: entry.rekomendasi.first!)
                }
                if entry.rekomendasi.count > 1 {
                    RekomendasiCardView(item: entry.rekomendasi.last!)
                }
            }
        }
        .padding(2)
    }
}

struct Widget_Seefood2: Widget {
    let kind: String = "Widget_Seefood2"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            MediumWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Rekomendasi Hari Ini")
        .description("Lihat rekomendasi makanan dan minuman hari ini.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    Widget_Seefood2()
} timeline: {
    SimpleEntry(date: .now, rekomendasi: [
        RekomendasiItem(nama: "Mie Laksa", lokasi: "The Breeze", jarak: "500m", harga: "Rp 45 K", imageName: "MB-1"),
        RekomendasiItem(nama: "Es Kelapa", lokasi: "GOP 9", jarak: "900m", harga: "Rp 35 K", imageName: "M-1")
    ])
    SimpleEntry(date: Date().addingTimeInterval(3600), rekomendasi: [
        RekomendasiItem(nama: "Nasi Ayam", lokasi: "GOP 6", jarak: "300m", harga: "Rp 35 K", imageName: "MB-2"),
        RekomendasiItem(nama: "Jus Wortel", lokasi: "The Breeze", jarak: "500m", harga: "Rp 20 K", imageName: "M-5")
    ])
}

// Dummy Image Assets (for Preview)
//extension Image {
//    static let mie_laksa = Image("MB-1")
//    static let soda_gembira = Image("MB-2")
//}

//#if DEBUG
//struct MieLaksa_Previews: PreviewProvider {
//    static var previews: some View {
//        Image("MB-3")
//            .resizable()
//            .frame(width: 100, height: 70)
//    }
//}
//
//struct SodaGembira_Previews: PreviewProvider {
//    static var previews: some View {
//        Image("MB-4")
//            .resizable()
//            .frame(width: 100, height: 70)
//    }
//}
//#endif
