//
//  LocarieView.swift
//  locarie
//
//  Created by qiuty on 2023/10/30.
//
import SwiftUI

struct LocarieView: View {
  @ObservedObject var router = Router.shared
  @ObservedObject var viewRouter = BottomTabViewRouter.shared

  var body: some View {
    NavigationStack(path: $router.path) {
      Group {
        switch viewRouter.currentPage {
        case .home:
          HomePage()
        case .new:
          NewPostPage()
        case .profile:
          UserProfilePage()
        }
      }
      .ignoresSafeArea(edges: .bottom)
      .navigationDestination(for: Router.Destination.self) { destination in
        router.getDestinationPage(with: destination)
      }
      .navigationDestination(for: Router.StringDestination.self) { destination in
        router.getStringDestinationPage(with: destination)
      }
    }
  }
}

#Preview {
  LocarieView()
}
