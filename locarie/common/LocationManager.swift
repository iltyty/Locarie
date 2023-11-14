//
//  LocationDataManager.swift
//  locarie
//
//  Created by qiuty on 2023/11/12.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let geocoder = CLGeocoder()
    let manager: CLLocationManager
    var locationFeaturesEnabled = false
    @Published var location: CLLocation?
    @Published var placemark: CLPlacemark?
    
    override init() {
        manager = CLLocationManager()
        super.init()
        manager.delegate = self
        requestLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            enableLocationFeatures()
        case .restricted, .denied:
            disableLocationFeatures()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            fatalError()
        }
    }
    
    func enableLocationFeatures() {
        locationFeaturesEnabled = true
    }
    
    func disableLocationFeatures() {
        locationFeaturesEnabled = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        print("Unable to retrive the location")
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = location
        geocode()
    }
    
    private func geocode() {
        guard let location = self.location else { return }
        geocoder.reverseGeocodeLocation(location) { places, error in
            self.placemark = error == nil ? places?[0] : nil
        }
    }
}
