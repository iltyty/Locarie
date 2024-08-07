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
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }

  private func prepareParameters(
    forQuery query: String,
    withOrigin origin: CLLocationCoordinate2D?
  ) -> Parameters {
    let authParams = prepareAuthParameters()
    let queryParams = prepareQueryParameters(forQuery: query)
    let countryParams = prepareCountryParams()
    let originParam = prepareOriginParameter(with: origin)
    return mergeParameters(authParams, queryParams, countryParams, originParam)
  }

  private func prepareQueryParameters(forQuery query: String) -> Parameters {
    [
      "q": query,
      "limit": 10,
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
