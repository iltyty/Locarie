//
//  BottomTabViewRouter.swift
//  locarie
//
//  Created by qiuty on 2023/11/6.
//

import SwiftUI

enum Page {
  case home
  case favorite
  case new
  case message
  case profile
}

class BottomTabViewRouter: ObservableObject {
  @Published var currentPage: Page = .home
}
