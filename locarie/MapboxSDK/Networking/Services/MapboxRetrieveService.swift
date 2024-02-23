//
//  MapboxRetrieveService.swift
//  locarie
//
//  Created by qiuty on 27/12/2023.
//

import Alamofire
import Combine
import Foundation

public protocol MapboxRetrieveService {
  func retrievePlace(forId mapboxId: String)
    -> AnyPublisher<PlaceRetrieveResponseDto, AFError>
}

public final class MapboxRetrieveServiceImpl: MapboxBaseService,
  MapboxRetrieveService
{
  static let shared = MapboxRetrieveServiceImpl()
  override private init() { super.init() }

  public func retrievePlace(forId mapboxId: String)
    -> AnyPublisher<PlaceRetrieveResponseDto, AFError>
  {
    let parameters = prepareAuthParameters()
    let url = MapboxAPIEndpoints.retrieve(mapboxId: mapboxId)
    return AF.request(url, parameters: parameters)
      .validate()
      .publishDecodable(
        type: PlaceRetrieveResponseDto.self, decoder: jsonDecoder
      )
      .value()
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
}
