//
//  MotionDetector.swift
//  SeeFood2Watch Watch App
//
//  Created by Satria Dafa Putra Wardhana on 26/05/25.
//

// MotionDetector.swift

import CoreMotion // Diperlukan untuk mengakses sensor gerak (accelerometer)
import Combine    // Diperlukan untuk menggunakan Publishers dan Subscribers
import WatchKit   // Diperlukan untuk memberikan haptic feedback

class MotionDetector: ObservableObject {
    // CMMotionManager adalah inti dari Core Motion untuk mengakses data sensor
    private let motionManager = CMMotionManager()
    
    // Set untuk menyimpan AnyCancellable dari Combine Publishers,
    // memastikan langganan dibatalkan saat objek deinit
    private var cancellables = Set<AnyCancellable>()
    
    // Thresholds untuk deteksi goyangan
    // Angka ini menentukan seberapa kuat percepatan yang dianggap sebagai goyangan.
    // Sesuaikan nilai ini untuk sensitivitas yang diinginkan.
    private let shakeThreshold: Double = 1.5 // Contoh: 1.5 G's (gravitasi)
    
    // Durasi minimum di mana percepatan harus melebihi threshold
    // untuk dianggap sebagai goyangan yang valid.
    private let shakeDuration: TimeInterval = 0.5 // 0.5 detik
    
    // Waktu terakhir goyangan terdeteksi, digunakan untuk mencegah deteksi berulang terlalu cepat
    private var lastShakeTime: Date?
    
    // Interval minimum antara dua goyangan yang terdeteksi
    private let shakeInterval: TimeInterval = 1.5 // 1.5 detik
    
    // Properti yang dipublikasikan (ObservableObject) yang akan diamati oleh SwiftUI View.
    // Bernilai 'true' saat goyangan terdeteksi, 'false' setelah jeda singkat.
    @Published var isShaking: Bool = false
    
    // Inisialisasi MotionDetector
    init() {
        // Cek apakah akselerometer tersedia di perangkat
        if motionManager.isAccelerometerAvailable {
            // Atur interval pembaruan data akselerometer (setiap 0.1 detik)
            motionManager.accelerometerUpdateInterval = 0.1
            
            // Mulai pembaruan akselerometer
            motionManager.startAccelerometerUpdates()
            
            // Gunakan Combine untuk menerima data akselerometer
            motionManager.publisher(for: \.accelerometerData) // Publisher untuk data akselerometer
                .compactMap { $0?.acceleration } // Ambil hanya data akselerasi (non-nil)
                .sink { [weak self] acceleration in // Sink (subscriber) untuk menerima nilai
                    // Panggil fungsi deteksi goyangan
                    self?.detectShake(acceleration)
                }
                .store(in: &cancellables) // Simpan langganan untuk pembatalan otomatis
        } else {
            // Cetak pesan jika akselerometer tidak tersedia (misalnya di simulator lama)
            print("Accelerometer is not available on this device.")
        }
    }
    
    // Dipanggil saat objek MotionDetector di-deinisialisasi (dihapus dari memori).
    // Penting untuk menghentikan pembaruan akselerometer untuk menghemat baterai.
    deinit {
        motionManager.stopAccelerometerUpdates()
    }
    
    // Fungsi inti untuk mendeteksi pola goyangan
    private func detectShake(_ acceleration: CMAcceleration) {
        let x = acceleration.x
        let y = acceleration.y
        let z = acceleration.z
        
        // Hitung magnitudo (besar) dari vektor percepatan.
        // Ini adalah akar kuadrat dari jumlah kuadrat komponen x, y, dan z.
        // Memberikan gambaran seberapa kuat perangkat bergerak secara keseluruhan.
        let magnitude = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2))
        
        // Cek apakah magnitudo melebihi threshold goyangan
        if magnitude > shakeThreshold {
            let now = Date()
            
            // Implementasi debounce:
            // Cek apakah goyangan terakhir terjadi dalam interval yang ditentukan.
            // Ini mencegah satu guncangan fisik memicu deteksi berkali-kali.
            if let lastShake = lastShakeTime {
                if now.timeIntervalSince(lastShake) < shakeInterval {
                    // Abaikan goyangan yang terlalu dekat (dalam shakeInterval)
                    return
                }
            }
            
            // Jika ini adalah goyangan yang valid dan baru
            isShaking = true // Set status goyangan menjadi true
            lastShakeTime = now // Catat waktu goyangan ini
            
            // Setelah mendeteksi goyangan, set isShaking kembali ke false setelah jeda singkat (shakeDuration).
            // Ini untuk memastikan 'isShaking' kembali ke false dan siap untuk goyangan berikutnya,
            // daripada terus-menerus 'true' selama guncangan.
            DispatchQueue.main.asyncAfter(deadline: .now() + shakeDuration) { [weak self] in
                self?.isShaking = false
            }
        }
    }
}
