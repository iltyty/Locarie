//
//  MapboxNeighborhoodLookupService.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import Alamofire
import Combine
import CoreLocation

public protocol MapboxNeighborhoodLookupService {
  func lookup(forLocation coordinate: CLLocationCoordinate2D)
    -> AnyPublisher<PlaceReverseLookupResponse, Never>
}

public final class MapboxNeighborhoodLookupServiceImpl: MapboxBaseService,
  MapboxNeighborhoodLookupService
{
  static let shared: MapboxNeighborhoodLookupService =
    MapboxNeighborhoodLookupServiceImpl()
  override private init() { super.init() }

  public func lookup(forLocation location: CLLocationCoordinate2D)
    -> AnyPublisher<PlaceReverseLookupResponse, Never>
  {
    let params = prepareParams(forLocation: location)
    return AF.request(MapboxAPIEndpoints.reverse, parameters: params)
      .validate()
      .publishDecodable(
        type: PlaceReverseLookupResponseDto.self,
        decoder: jsonDecoder
      )
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
}

private extension MapboxNeighborhoodLookupServiceImpl {
  private func prepareParams(forLocation location: CLLocationCoordinate2D)
    -> Parameters
  {
    let tokenParams = prepareAccessTokenParam()
    let queryParams = prepareQueryParams(with: location)
    let countryParams = prepareCountryParams()
    return mergeParameters(tokenParams, queryParams, countryParams)
  }

  private func prepareQueryParams(with location: CLLocationCoordinate2D)
    -> Parameters
  {
    [
      "longitude": location.longitude,
      "latitude": location.latitude,
      "types": "neighborhood",
    ]
  }
}

public typealias PlaceReverseLookupResponse = DataResponse<
  PlaceReverseLookupResponseDto, AFError
>
