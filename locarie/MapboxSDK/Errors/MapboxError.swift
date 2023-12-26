//
//  MapboxError.swift
//  locarie
//
//  Created by qiuty on 26/12/2023.
//

import Foundation

enum MapboxError: Error {
  case noInternet
  case backend(Int)
}
