//
//  BottomTabViewRouter.swift
//  locarie
//
//  Created by qiuty on 2023/11/6.
//

import SwiftUI

class BottomTabViewRouter: ObservableObject {
  static let shared = BottomTabViewRouter()
  private init() {}

  @Published var currentPage: Page = .home
}

enum Page {
  case home
  case new
  case profile
}
