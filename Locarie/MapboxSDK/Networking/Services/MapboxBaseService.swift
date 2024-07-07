//
//  MapboxBaseService.swift
//  locarie
//
//  Created by qiuty on 27/12/2023.
//

import Alamofire
import Foundation

public class MapboxBaseService {
  let accessToken: String
  let sessionToken: String

  let jsonDecoder: JSONDecoder

  private static let accessTokenKey = "MBXAccessToken"

  init() {
    accessToken = MapboxBaseService.getAccessToken()
    sessionToken = UUID().uuidString
    jsonDecoder = JSONDecoder()
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
  }

  private static func getAccessToken() -> String {
    let accessToken = Bundle.main.object(
      forInfoDictionaryKey: MapboxBaseService.accessTokenKey
    ) as? String
    return accessToken ?? ""
  }

  func prepareAccessTokenParam() -> Parameters {
    ["access_token": accessToken]
  }

  func prepareCountryParams() -> Parameters {
    ["country": "gb"]
  }

  func prepareAuthParameters() -> Parameters {
    [
      "access_token": accessToken,
      "session_token": sessionToken,
    ]
  }

  func mergeParameters(_ parameters: Parameters...) -> Parameters {
    parameters.reduce(Parameters()) { result, parameter in
      result.merging(parameter) { current, _ in current }
    }
  }
}
