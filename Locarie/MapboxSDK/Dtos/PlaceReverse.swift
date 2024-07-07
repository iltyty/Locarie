//
//  PlaceReverse.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import Foundation

public struct PlaceReverseLookupResponseDto: Codable {
  let features: [PlaceReverseLookupDto]
}

public struct PlaceReverseLookupDto: Codable {
  let properties: PlaceProperty
}
