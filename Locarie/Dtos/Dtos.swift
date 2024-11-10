//
//  Dtos.swift
//  locarie
//  Created by qiuty on 10/12/2023.
//

import Foundation

struct ResponseDto<T: Decodable>: Decodable {
  let status: Int
  let message: String
  let data: T?
}
