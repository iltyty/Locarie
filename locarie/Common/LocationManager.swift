//
//  LocationManager.swift
//  locarie
//
//  Created by qiuty on 2023/11/12.
//

import CoreLocation
import Foundation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
  private let geocoder = CLGeocoder()
  let manager: CLLocationManager
  var locationFeaturesEnabled = false
  @Published var location: CLLocation?
  @Published var placemark: CLPlacemark?

  override init() {
    manager = CLLocationManager()
    super.init()
    manager.delegate = self
    setup()
  }

  private func setup() {
    switch manager.authorizationStatus {
    case .authorizedWhenInUse, .authorizedAlways:
      manager.startUpdatingLocation()
      enableLocationFeatures()
    case .restricted, .denied:
      disableLocationFeatures()
    case .notDetermined:
      manager.requestWhenInUseAuthorization()
    @unknown default:
      fatalError()
    }
  }
}

extension LocationManager {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    guard manager.authorizationStatus == .authorizedWhenInUse ||
      manager.authorizationStatus == .authorizedAlways
    else {
      return
    }
    manager.startUpdatingLocation()
  }

  func enableLocationFeatures() {
    locationFeaturesEnabled = true
  }

  func disableLocationFeatures() {
    locationFeaturesEnabled = false
  }

  func locationManager(_: CLLocationManager, didFailWithError error: Error) {
    print(error.localizedDescription)
    print("Unable to retrive the location")
  }

  func locationManager(
    _: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    guard let location = locations.last else { return }
    self.location = location
    manager.stopUpdatingLocation()
  }

  private func geocode() {
    guard let location else { return }
    geocoder.reverseGeocodeLocation(location) { places, error in
      self.placemark = error == nil ? places?[0] : nil
    }
  }
}
