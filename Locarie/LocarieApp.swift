//
//  LocarieApp.swift
//  Locarie
//
//  Created by qiuty on 2023/10/30.
//

import Kingfisher
import SwiftUI

@main
struct LocarieApp: App {
  var body: some Scene {
    WindowGroup {
      LocarieView()
        .environment(\.font, Font.custom(GlobalConstants.fontName, size: 16, relativeTo: .body))
        .onAppear {
          ImageCache.default.memoryStorage.config.totalCostLimit = 300 * 1024 * 1024
        }
    }
  }
}
