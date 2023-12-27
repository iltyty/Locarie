//
//  PlaceRetrieve.swift
//  locarie
//
//  Created by qiuty on 27/12/2023.
//

import Foundation

public struct PlaceRetrieveResponseDto: Codable {
  let features: [PlaceRetrieveDto]
}

public struct PlaceRetrieveDto: Codable {
  let geometry: PlaceGeometry
  let properties: PlaceProperty
}

struct PlaceGeometry: Codable {
  let coordinates: [Double]
}

struct PlaceProperty: Codable {
  let name: String
  let namePreferred: String?
  let address: String?
  let fullAddress: String?
  let placeFormatted: String?
  let coordinates: PlaceCoordinate
}

struct PlaceCoordinate: Codable {
  let latitude: Double
  let longitude: Double
}
