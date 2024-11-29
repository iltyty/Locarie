//
//  PaginatedDto.swift
//  Locarie
//
//  Created by qiu on 2024/11/9.
//

import Foundation

struct PaginatedResponseDto<T: Decodable>: Decodable {
  let status: Int
  let message: String
  let data: PaginatedData<T>
}

struct PaginatedData<T: Decodable>: Decodable {
  let content: [T]
  let page: Pageable
  
  var last: Bool {
    page.number + 1 == page.totalPages
  }
}

struct Pageable: Decodable {
  let size: Int
  let number: Int
  let totalPages: Int
  let totalElements: Int
}
