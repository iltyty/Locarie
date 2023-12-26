//
//  MapboxService.swift
//  locarie
//
//  Created by qiuty on 26/12/2023.
//

import Alamofire
import Combine
import CoreLocation
import Foundation

public protocol MapboxService {
  func getPlaceSuggestions(
    forPlace place: String, withOrigin origin: CLLocationCoordinate2D?
  ) -> AnyPublisher<PlaceSuggestionsResponseDto, AFError>
}

public final class MapboxServiceImpl: MapboxService {
  private static let accessTokenKey = "MBXAccessToken"
  static let shared: MapboxService = MapboxServiceImpl()

  private let accessToken: String
  private var sessionToken: String

  private let jsonDecoder: JSONDecoder

  private init() {
    accessToken = MapboxServiceImpl.getMapboxAccessToken()
    sessionToken = UUID().uuidString
    jsonDecoder = JSONDecoder()
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
  }

  private static func getMapboxAccessToken() -> String {
    let accessToken = Bundle.main.object(
      forInfoDictionaryKey: MapboxServiceImpl.accessTokenKey
    ) as? String
    return accessToken ?? ""
  }
}

public extension MapboxServiceImpl {
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
    forQuery query: String, withOrigin origin: CLLocationCoordinate2D?
  )
    -> Parameters
  {
    let baseDict = getBaseDict(forQuery: query)
    let originDict = getOriginDict(with: origin)
    return baseDict.merging(originDict) { current, _ in current }
  }

  private func getBaseDict(forQuery query: String) -> [String: Any] {
    [
      "q": query,
      "access_token": accessToken,
      "session_token": sessionToken,
      "limit": MapboxServiceImpl.resultNumLimit,
      "country": "GB",
    ] as [String: Any]
  }

  private func getOriginDict(with origin: CLLocationCoordinate2D?)
    -> [String: String]
  {
    guard let origin else {
      return [:]
    }
    return [
      "origin": "\(origin.longitude), \(origin.latitude)",
    ]
  }
}

private extension MapboxServiceImpl {
  static let resultNumLimit = 5
}
