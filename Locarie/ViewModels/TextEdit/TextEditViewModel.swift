//
//  TextEditViewModel.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import Foundation

final class TextEditViewModel: ObservableObject {
  let limit: Int

  init(limit: Int) {
    self.limit = limit
  }

  @Published var text = "" {
    didSet {
      if text.count > limit, oldValue.count <= limit {
        text = oldValue
      }
    }
  }
}
