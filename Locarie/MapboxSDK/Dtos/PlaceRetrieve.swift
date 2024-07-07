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
