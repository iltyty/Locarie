//
//  locarieApp.swift
//  locarie
//
//  Created by qiuty on 2023/10/30.
//

import SwiftUI

@main
struct locarieApp: App {
  var body: some Scene {
    WindowGroup {
      LocarieView()
        .environment(\.font, Font.custom(GlobalConstants.fontName, size: 16, relativeTo: .body))
    }
  }
}
