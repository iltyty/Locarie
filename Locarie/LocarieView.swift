//
//  LocarieView.swift
//  locarie
//
//  Created by qiuty on 2023/10/30.
//
import Kingfisher
import SwiftUI

struct LocarieView: View {
  @ObservedObject private var router = Router.shared
  @ObservedObject private var viewRouter = BottomTabViewRouter.shared

  var body: some View {
    NavigationStack(path: $router.path) {
      Group {
        switch viewRouter.currentPage {
        case .home:
          HomePage()
        case .profile:
          UserProfilePage()
        case .none:
          EmptyView()
        }
      }
      .navigationBarBackButtonHidden()
      .ignoresSafeArea(edges: .bottom)
      .navigationDestination(for: Router.Destination.self) { dest in
        router.getDestinationPage(with: dest)
      }
      .navigationDestination(for: Router.StringDestination.self) { dest in
        router.getStringDestinationPage(with: dest)
      }
      .navigationDestination(for: Router.BusinessHomeDestination.self) { dest in
        router.getBusinessHomePage(with: dest)
      }
    }
  }
}

#Preview { LocarieView() }
