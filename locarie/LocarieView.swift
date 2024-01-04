//
//  LocarieView.swift
//  locarie
//
//  Created by qiuty on 2023/10/30.
//

import CoreLocation
import SwiftUI

struct LocarieView: View {
  @State var path = [Route]()

  @EnvironmentObject var viewRouter: BottomTabViewRouter

  var body: some View {
    NavigationStack {
      content
        .navigationDestination(for: Route.self) { route in
          getRoutePage(route, path: $path)
        }
    }
  }

  @ViewBuilder
  var content: some View {
    switch viewRouter.currentPage {
    case .home:
      HomePage()
    case .favorite:
      FavoritePage()
    case .new:
      NewPostPage()
    case .message:
      MessagePage()
    case .profile:
      UserProfilePage()
    }
  }
}

#Preview {
  LocarieView()
    .environmentObject(BottomTabViewRouter())
    .environmentObject(MessageViewModel())
    .environmentObject(LocalCacheViewModel())
}
