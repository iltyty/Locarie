//
//  locarieApp.swift
//  locarie
//
//  Created by qiuty on 2023/10/30.
//

import SwiftUI

@main
struct locarieApp: App {
  @StateObject var router = Router.shared
  @StateObject var viewRouter = BottomTabViewRouter.shared
  @StateObject var postViewModel = PostViewModel()
  @StateObject var messageViewModel = MessageViewModel()

  var body: some Scene {
    WindowGroup {
      LocarieView()
        .environmentObject(router)
        .environmentObject(postViewModel)
        .environmentObject(messageViewModel)
    }
  }
}
