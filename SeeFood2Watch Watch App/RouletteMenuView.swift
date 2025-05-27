import SwiftUI
import WatchKit // Diperlukan untuk haptic feedback

// MARK: - RouletteMenuView
struct RouletteMenuView: View {
    @State private var rotationAngle: Angle = .zero
    @State private var selectedIndex: Int = 0
    @State private var isSpinning: Bool = false
    @State private var recommendedItem: MenuItem? // Kembali menggunakan MenuItem
    @State private var showResultScreen: Bool = false

    let menuItems: [MenuItem] = MenuItem.all // Mengambil data dari MenuItem.all
    
    // Jumlah segmen akan disesuaikan dengan jumlah menuItems
    private var numberOfSegments: Int {
        menuItems.count
    }

    // Sudut untuk setiap segmen
    private var segmentAngle: Angle {
        .degrees(360 / Double(numberOfSegments))
    }

    var body: some View {
        VStack {
            if showResultScreen, let recommendedItem = recommendedItem {
                // MARK: - Tampilan Hasil Rekomendasi
                VStack {
                    Text("Rekomendasi SeeFood:")
                        .font(.headline)
                        .padding(.bottom, 2)
                    Text(recommendedItem.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
//                    Text(recommendedItem.description) // Tampilkan deskripsi
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                        .multilineTextAlignment(.center)
//                        .padding(.top, 1)
                    Text(recommendedItem.price) // Tampilkan harga
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.top, 1)
                    
                    Spacer()

                    VStack(spacing: 8) {
                        Button("Pilih Menu Ini") {
                            print("Pilih Menu: \(recommendedItem.name)")
                            self.resetToRoulette()
                        }
                        .tint(.green)
                        
                        Button("Putar Lagi") {
                            resetAndSpin()
                        }
                        .tint(.accentColor)
                    }
                }
                .padding()
            } else {
                // MARK: - Tampilan Roda Roulette
                GeometryReader { geometry in
                    let wheelDiameter: CGFloat = min(geometry.size.width, geometry.size.height) - 10
                    let wheelRadius = wheelDiameter / 2

                    ZStack {
                        // Lingkaran luar roda
                        Circle()
                            .stroke(lineWidth: 6)
                            .foregroundColor(.gray)
                            .shadow(radius: 5)
                            .frame(width: wheelDiameter, height: wheelDiameter)

                        // Segmen-segmen roulette
                        ForEach(0..<numberOfSegments, id: \.self) { index in
                            let startAngle = segmentAngle * Double(index)
                            let endAngle = segmentAngle * Double(index + 1)
                            
                            SegmentShape(startAngle: startAngle, endAngle: endAngle)
                                .fill(colorForIndex(index))
                                .frame(width: wheelDiameter, height: wheelDiameter)
                                .overlay(
                                    SegmentShape(startAngle: startAngle, endAngle: endAngle)
                                        .stroke(Color.black.opacity(0.3), lineWidth: 1)
                                        .frame(width: wheelDiameter, height: wheelDiameter)
                                )
                        }
                        
                        // Lingkaran pusat roda
                        Circle()
                            .fill(Color.orange)
                            .frame(width: wheelDiameter * 0.2, height: wheelDiameter * 0.2)
                            .overlay(
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                    .rotationEffect(rotationAngle) // Hanya roda yang berputar
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
                    // Panah penunjuk (TIDAK BERPUTAR bersama roda)
                    Image(systemName: "arrowtriangle.down.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.red)
                        .offset(y: -wheelRadius - 15) // Sesuaikan offset
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)

                }
                .padding(.horizontal)

                Button(isSpinning ? "Memutar..." : "Putar Roulette") {
                    if !isSpinning {
                        spinRoulette()
                    }
                }
                .disabled(isSpinning)
                .padding(.top, 10)
            }
        }
        .navigationTitle("Roulette")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Fungsi-fungsi Logika
    func spinRoulette() {
        isSpinning = true
        recommendedItem = nil // Reset rekomendasi sebelumnya
        showResultScreen = false

        let randomSpins = Double.random(in: 3...6) * 360
        let randomStopAngle = Double.random(in: 0..<360)
        let finalAngle = rotationAngle.degrees + randomSpins + randomStopAngle

        withAnimation(.easeOut(duration: 3.0)) {
            rotationAngle = .degrees(finalAngle)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
            self.stopRoulette()
        }
    }

    func stopRoulette() {
        isSpinning = false
        
        var normalizedAngle = rotationAngle.degrees.truncatingRemainder(dividingBy: 360)
        if normalizedAngle < 0 {
            normalizedAngle += 360
        }

        // Logika penentuan indeks:
        // Panah penunjuk berada di posisi tetap di atas (`.offset(y: -wheelRadius - 15)`).
        // Secara visual, panah menunjuk ke arah 'atas', yang dalam sistem koordinat SwiftUI (0 kanan, 90 atas) adalah 90 derajat.

        let targetPointerAngle: Double = 90 // Panah menunjuk ke atas (90 derajat dari kanan)

        // Sudut pada roda yang berada tepat di bawah panah
        // Kita ingin mengetahui segmen mana yang posisinya sekarang ada di 'targetPointerAngle'
        // Jika roda berputar `normalizedAngle` searah jarum jam (rotationAngle positif).
        // Maka item yang awalnya di 0 derajat (kanan) akan berada di `normalizedAngle` derajat.
        // Item yang berada di bawah pointer adalah item yang awalnya berada di `(targetPointerAngle - normalizedAngle + 360) % 360`
        
        let angleAtPointer = (targetPointerAngle - normalizedAngle + 360).truncatingRemainder(dividingBy: 360)
        
        // Hitung indeks berdasarkan sudut tersebut
        // selectedIndex = Int(angleAtPointer / segmentAngle.degrees)
        // Karena kita ingin indeks sesuai dengan urutan alami di `menuItems` (dari 0 ke N-1),
        // dan putaran searah jarum jam, kita perlu menyesuaikan hitungan indeks.
        
        // Jika item 0 dimulai dari 0 derajat (kanan) dan segmen bertambah searah jarum jam.
        // Panah di 90 derajat (atas).
        // Jika roda berhenti di mana 0 derajat ada di 90 derajat, maka item 0 terpilih.
        // Jika roda berhenti di mana 90 derajat ada di 90 derajat, maka item 1 terpilih.
        // Jadi, indeks adalah (sudut item / segmentAngle.degrees).
        // Kita perlu membalik urutan indeks dari angleAtPointer karena angleAtPointer berkurang saat roda berputar searah jarum jam.
        
        selectedIndex = Int(angleAtPointer / segmentAngle.degrees)
        
        // Pastikan indeks berada dalam batas array
        selectedIndex = selectedIndex % numberOfSegments
        if selectedIndex < 0 {
            selectedIndex += numberOfSegments
        }
        
        // Final adjustment to ensure correct item is picked visually.
        // This often depends on how the segments are drawn (clockwise/counter-clockwise)
        // and where the first item is placed.
        // If the calculated selectedIndex is consistently off by a fixed number, adjust here.
        // For example, if you have 8 items and it's always one off:
        // selectedIndex = (selectedIndex + 1) % numberOfSegments // Adjust if it's always off by 1
        
        // Since `MenuItem.all` might be shuffled, the order matters.
        // Let's assume segment 0 corresponds to menuItems[0], segment 1 to menuItems[1], etc.
        // If the calculation above works, good. If not, trial and error is sometimes needed.
        
        // To ensure correct item selection when using .shuffled() or a specific order,
        // it's crucial that the `targetPointerAngle` and the `startAngle`
        // of your first item (index 0) are correctly aligned.
        
        // If item 0 is at 0 degrees (right), and pointer is at 90 degrees (top).
        // When the wheel rotates +X degrees, the item at (0+X) is now at pointer's position.
        // We want (angle of item currently at pointer) / segmentAngle.degrees
        
        // Let's try reversing the logic one more time if the current one is still off.
        // The angle that determines the selection is where the pointer is relative to the *start* of the segment.
        // If the wheel has rotated by `normalizedAngle`, and the pointer is at `targetPointerAngle` (90 degrees).
        // The item at `selectedIndex` would ideally have its start angle at `targetPointerAngle`.
        // So, `targetPointerAngle` should fall within `startAngle` and `endAngle` of the selected segment.
        
        // Correcting the index calculation based on pointer at 90 degrees (top)
        // and segments starting from 0 degrees (right) increasing counter-clockwise for SegmentShape's 'false'.
        // Or if clockwise: false means segment 0 is at 0-X degrees clockwise.
        // If segment 0 is from 0 to 45 deg (clockwise), and pointer is at 90.
        // The angle of the segment at pointer's position would be (90 - normalizedAngle + 360) % 360
        // This should be the selected index.

        // After much trial and error with roulette logic, the most robust way often is:
        // 1. Determine the final angle of the wheel relative to its starting point (0 degrees).
        // 2. Adjust this angle so that 0 degrees aligns with your pointer's position.
        // 3. Divide this adjusted angle by the segment size to get the index.
        
        let adjustedAngleForPointer = (normalizedAngle - targetPointerAngle + 360).truncatingRemainder(dividingBy: 360)
        // The index calculation assumes segments are laid out from 0 degrees.
        // If segment 0 starts at 0 degrees, and moves clockwise, the index is simple.
        // If segment 0 starts at 0 degrees and moves counter-clockwise (due to SegmentShape `clockwise: false`),
        // then the angles increase counter-clockwise.
        // Our pointer is at 90 degrees.
        // Let's re-evaluate: if normalizedAngle is 0, item 0 is at 0. Pointer is at 90.
        // If item 0 is selected, wheel must turn such that item 0 is at 90. So rotationAngle = 90.
        // `normalizedAngle` will be 90.
        // `(targetPointerAngle - normalizedAngle + 360) % 360` = (90 - 90 + 360) % 360 = 0. So index 0 selected. This works!
        // `(targetPointerAngle - normalizedAngle + 360) % 360` = (90 - 180 + 360) % 360 = 270.
        // If item 1 is at 45 degrees, and rotated to 90 degrees, normalizedAngle would be 45 degrees.
        // (90 - 45 + 360) % 360 = 45. Index 1 selected. This logic seems correct.

        selectedIndex = Int(angleAtPointer / segmentAngle.degrees)
        
        // Final sanity check for index bounds, though it should be handled by modulo.
        selectedIndex = max(0, min(selectedIndex, numberOfSegments - 1))
        
        // Now, set the recommended item from your menuItems array
        recommendedItem = menuItems[selectedIndex]
        showResultScreen = true
        WKInterfaceDevice.current().play(.success)
    }

    func resetAndSpin() {
        recommendedItem = nil
        showResultScreen = false
        spinRoulette()
    }
    
    func resetToRoulette() {
        recommendedItem = nil
        showResultScreen = false
    }

    private func colorForIndex(_ index: Int) -> Color {
        let colors: [Color] = [.yellow, .red, .orange, .blue, .green, .purple, .pink, .cyan, .brown, .mint]
        return colors[index % colors.count]
    }
}

// MARK: - SegmentShape (Custom Shape untuk Juring Lingkaran)
struct SegmentShape: Shape {
    var startAngle: Angle
    var endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        path.move(to: center)
        path.addArc(center: center,
                     radius: radius,
                     startAngle: startAngle,
                     endAngle: endAngle,
                     clockwise: false) // 'false' berarti menggambar busur berlawanan arah jarum jam
        path.closeSubpath()
        return path
    }
}

// MARK: - Preview Provider
#Preview {
    RouletteMenuView()
}
