//
//  BioEditViewModel.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import Foundation

final class BioEditViewModel: ObservableObject {
  @Published var text = "" {
    didSet {
      if text.count > limit, oldValue.count <= limit {
        text = oldValue
      }
      remainingCount = limit - text.count
    }
  }

  @Published var remainingCount: Int

  let limit: Int

  init(limit: Int = 150) {
    self.limit = limit
    remainingCount = limit
  }
}
