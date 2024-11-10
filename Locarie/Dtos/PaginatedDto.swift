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
  let totalPages: Int
  let totalElements: Int
  let last: Bool
  let pageable: Pageable
}

struct Pageable: Decodable {
  let pageNumber: Int
}
