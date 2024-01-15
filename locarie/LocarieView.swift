//
//  LocarieView.swift
//  locarie
//
//  Created by qiuty on 2023/10/30.
//

import CoreLocation
import SwiftUI

struct LocarieView: View {
  @ObservedObject var router = Router.shared
  @ObservedObject var viewRouter = BottomTabViewRouter.shared

  var body: some View {
    NavigationStack(path: $router.path) {
      content
        .navigationDestination(for: Router.Destination.self) { destination in
          router.getDestinationPage(with: destination)
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
    .environmentObject(MessageViewModel())
}
