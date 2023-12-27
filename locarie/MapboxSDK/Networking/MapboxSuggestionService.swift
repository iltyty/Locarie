//
//  MapboxSuggestionService.swift
//  locarie
//
//  Created by qiuty on 26/12/2023.
//

import Alamofire
import Combine
import CoreLocation
import Foundation

public protocol MapboxSuggestionService {
  func getPlaceSuggestions(
    forPlace place: String, withOrigin origin: CLLocationCoordinate2D?
  ) -> AnyPublisher<PlaceSuggestionsResponseDto, AFError>
}

public final class MapboxSuggestionServiceImpl: MapboxBaseService,
  MapboxSuggestionService
{
  static let shared: MapboxSuggestionService = MapboxSuggestionServiceImpl()
  override private init() { super.init() }
}

public extension MapboxSuggestionServiceImpl {
  func getPlaceSuggestions(
    forPlace place: String, withOrigin origin: CLLocationCoordinate2D?
  ) -> AnyPublisher<PlaceSuggestionsResponseDto, AFError> {
    let parameters = prepareParameters(forQuery: place, withOrigin: origin)
    return AF.request(MapboxAPIEndpoints.suggest, parameters: parameters)
      .validate()
      .publishDecodable(
        type: PlaceSuggestionsResponseDto.self,
        decoder: jsonDecoder
      )
      .value()
      .eraseToAnyPublisher()
  }

  private func prepareParameters(
    forQuery query: String,
    withOrigin origin: CLLocationCoordinate2D?
  ) -> Parameters {
    let baseParams = prepareAuthParameters()
    let queryParams = prepareQueryParameters(forQuery: query)
    let originParam = prepareOriginParameter(with: origin)
    return mergeParameters(baseParams, queryParams, originParam)
  }

  private func prepareQueryParameters(forQuery query: String) -> Parameters {
    [
      "q": query,
      "country": "GB",
    ]
  }

  private func prepareOriginParameter(
    with origin: CLLocationCoordinate2D?
  ) -> Parameters {
    guard let origin else {
      return [:]
    }
    return [
      "origin": "\(origin.longitude), \(origin.latitude)",
    ]
  }
}
