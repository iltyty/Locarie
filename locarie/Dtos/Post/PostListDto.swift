//
//  PostListDto.swift
//  locarie
//
//  Created by qiuty on 20/12/2023.
//

import Foundation

struct PostListRequestDto: Codable {
  let latitude: Double
  let longitude: Double
  let distance: Double
}
