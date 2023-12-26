//
//  MapboxAPIEndpoints.swift
//  locarie
//
//  Created by qiuty on 26/12/2023.
//

import Foundation

public enum MapboxAPIEndpoints {
  static let suggest = URL(
    string: "https://api.mapbox.com/search/searchbox/v1/suggest"
  )!
  static let retrieve = URL(
    string: "https://api.mapbox.com/search/searchbox/v1/retrieve"
  )!
}
