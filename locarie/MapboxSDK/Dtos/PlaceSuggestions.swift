//
//  PlaceSuggestions.swift
//  locarie
//
//  Created by qiuty on 26/12/2023.
//

import Foundation

public struct PlaceSuggestionDto: Codable, Hashable {
  let name: String
  let namePreferred: String?
  let mapboxId: String
  let address: String?
  let fullAddress: String?
  let placeFormatted: String?
  let distance: Double?
}

public struct PlaceSuggestionsResponseDto: Codable {
  let suggestions: [PlaceSuggestionDto]
}
