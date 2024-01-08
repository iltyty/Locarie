//
//  Binding+Hashable.swift
//  locarie
//
//  Created by qiuty on 08/01/2024.
//

import SwiftUI

extension Binding: Equatable where Value: Equatable {
  public static func == (lhs: Binding<Value>, rhs: Binding<Value>) -> Bool {
    lhs.wrappedValue == rhs.wrappedValue
  }
}

extension Binding: Hashable where Value: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(wrappedValue.hashValue)
  }
}
