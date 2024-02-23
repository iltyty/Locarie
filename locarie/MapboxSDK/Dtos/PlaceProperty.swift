//
//  PlaceProperty.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

struct PlaceProperty: Codable {
  let name: String
  let namePreferred: String?
  let address: String?
  let fullAddress: String?
  let placeFormatted: String?
  let coordinates: PlaceCoordinate
  let context: PlaceContext
}

struct PlaceCoordinate: Codable {
  let latitude: Double
  let longitude: Double
}

struct PlaceContext: Codable {
  let neighborhood: PlaceNeighborhood
}

struct PlaceNeighborhood: Codable {
  let name: String
}
