import SwiftUI
import CoreLocation

class LocationManagers: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocation?
    @Published var userAddress: String = "Mendapatkan Alamat..."

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        requestLocationAuthorization() // Minta izin saat inisialisasi
    }

    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    // CLLocationManagerDelegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location
            reverseGeocodeLocation(location: location)
            stopUpdatingLocation() // Hentikan pembaruan setelah mendapatkan lokasi awal (opsional)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error.localizedDescription)")
        userAddress = "Alamat masih dalam pencarian...  "
    }

    // Reverse Geocoding
    private func reverseGeocodeLocation(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocoding failed with error: \(error.localizedDescription)")
                self.userAddress = "Gagal Menerjemahkan Alamat"
                return
            }

            if let placemark = placemarks?.first {
                let street = placemark.thoroughfare ?? ""
                let subLocality = placemark.subLocality ?? ""
                let locality = placemark.locality ?? ""
                let administrativeArea = placemark.administrativeArea ?? ""
                let postalCode = placemark.postalCode ?? ""
                let country = placemark.country ?? ""

                self.userAddress = "\(street), \(subLocality), \(locality), \(administrativeArea) \(postalCode), \(country)"
            } else {
                self.userAddress = "Alamat Tidak Ditemukan"
            }
        }
    }
}
