//
//  MapboxAPIEndpoints.swift
//  locarie
//
//  Created by qiuty on 26/12/2023.
//

import CoreLocation
import Foundation

public enum MapboxAPIEndpoints {
  static let suggest = URL(
    string: "https://api.mapbox.com/search/searchbox/v1/suggest"
  )!
  static func retrieve(mapboxId id: String) -> URL {
    URL(
      string: "https://api.mapbox.com/search/searchbox/v1/retrieve/\(id)"
    )!
  }

  static let reverse = URL(
    string: "https://api.mapbox.com/search/geocode/v6/reverse"
  )!
}
