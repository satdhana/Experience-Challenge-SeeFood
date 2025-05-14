//
//  NavigationMapView.swift
//  SeeFood2
//
//  Created by Satria Dafa Putra Wardhana on 09/05/25.
//

import SwiftUI
import MapKit

struct MapViewWithSwiftUI: View {
    @State private var position: MapCameraPosition = .automatic
    @State private var arrivedButtonVisible: Bool = false
    @StateObject private var locationManager = LocationManager()
    
    let locations = [
        Location(name: "Traveloka Campus", latitude: -6.302786900319068, longitude: 106.6515491053045),
        Location(name: "GOP 6", latitude: -6.303015263169143, longitude: 106.65284093993468), // Ganti koordinat
        Location(name: "Green Office Park 9", latitude: -6.3016416811797455, longitude: 106.65057510507872)  // Ganti koordinat
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: $position) {
                ForEach(locations) { location in
                    Annotation(location.name, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                        NavigationLink(destination: Text("Tenant List for \(location.name)")) { // Ganti dengan TenantListView
                            VStack {
                                Image(systemName: "mappin.circle.fill")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                UserAnnotation()
            }
            .tint(.green)
            .onAppear {
                locationManager.requestWhenInUseAuthorization()
                // Set initial map position to user's location if available
                if let userLocation = locationManager.location {
                    position = .userLocation(fallback: MapCameraPosition.region(
                        MKCoordinateRegion(
                            center: userLocation.coordinate,
                            latitudinalMeters: 500, // Sesuaikan jarak pandang vertikal
                            longitudinalMeters: 500 // Sesuaikan jarak pandang horizontal
                        )
                    ))
                } else {
                    // Set a default fallback position if user location is not available
                    position = .region(MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: -6.302786900319068, longitude: 106.6520991053045), // Contoh: Jakarta
                        latitudinalMeters: 200,
                        longitudinalMeters: 200
                    ))
                }
                // Simulate arrival after 5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    arrivedButtonVisible = true
                }
            }
            
//            if arrivedButtonVisible {
                Button {
                    print("You've Arrived! Button Tapped")
                    // Handle arrival logic here
                } label: {
                    HStack {
                        Image(systemName: "checkmark.seal")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        Text("You've Arrived!")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)
                }
                .padding()
//            }
        }
    }
}

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
}

// Simple LocationManager (you might have your own)
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first
    }
}

struct MapViewWithSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        MapViewWithSwiftUI()
    }
}
