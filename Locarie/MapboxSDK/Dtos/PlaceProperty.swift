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
  let address: PlaceContextItem?
  let country: PlaceContextItem?
  let district: PlaceContextItem?
  let locality: PlaceContextItem?
  let neighborhood: PlaceContextItem?
  let place: PlaceContextItem?
  let postcode: PlaceContextItem?
  let street: PlaceContextItem?
}

struct PlaceContextItem: Codable {
  let name: String
}
