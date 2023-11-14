//
//  util.swift
//  locarie
//
//  Created by qiuty on 2023/11/11.
//

import Foundation
import CoreLocation

func getTimeDifferenceString(from time: Date) -> String {
    let calendar = Calendar.current
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let components = calendar.dateComponents([.second, .minute, .hour, .day, .month, .year], from: time, to: Date.now)

    return if let years = components.year, years > 0 {
        formatter.string(from: time)
    } else if let months = components.month, months > 0 {
        "\(months) months ago"
    } else if let days = components.day, days > 0 {
        "\(days) days ago"
    } else if let hours = components.hour, hours > 0 {
        "\(hours) hours ago"
    } else if let minutes = components.minute, minutes > 0 {
        "\(minutes) mins ago"
    } else if let seconds = components.second {
        "\(seconds) seconds ago"
    } else {
        "just now"
    }
}

func formatOpeningTime(from openTime: DateComponents, to closeTime: DateComponents) -> String {
    String(format: "%02d:%02d - %02d:%02d", openTime.hour ?? 0, openTime.minute ?? 0,
                     closeTime.hour ?? 0, closeTime.minute ?? 0)
}

func formatDistance(distance: Double) -> String {
    return switch distance {
    case 0..<1000:
        String(format: "%.f m", distance)
    default:
        String(format: "%.1f km", distance / 1000)
    }
}

func getLocationName(location: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
    let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
    CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
        guard let placemark = placemarks?.first, error == nil else {
            completion(nil)
            return
        }
        completion(placemark.description)
    }
}

func createLondonRegion() -> CLRegion {
    let center = CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278)
    let radius = 1000.0 // 半径为1公里
    let identifier = "London"
    
    return CLCircularRegion(center: center, radius: radius, identifier: identifier)
}

func getLocationCoordinate(location: String, completion: @escaping (CLLocation?) -> Void) {
    CLGeocoder().geocodeAddressString(location) { placemarks, error in
        guard let placemark = placemarks?.first, error == nil else {
            completion(nil)
            return
        }
        guard let location = placemark.location else {
            completion(nil)
            return
        }
        completion(location)
    }
}
