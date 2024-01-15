//
//  UserDefaults+Reset.swift
//  locarie
//
//  Created by qiuty on 15/01/2024.
//

import Foundation

extension UserDefaults {
  func reset() {
    LocalCacheKeys.allCases.forEach { key in
      removeObject(forKey: key.rawValue)
    }
  }
}
