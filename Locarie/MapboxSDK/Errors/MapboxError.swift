//
//  MapboxError.swift
//  locarie
//
//  Created by qiuty on 26/12/2023.
//

import Alamofire
import Foundation

public enum MapboxError: Error {
  case noInternet
  case backend(Int)
  case unknown(AFError)
}
