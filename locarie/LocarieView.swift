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
      .navigationDestination(for: Router.Destination.self) { destination in
        router.getDestinationPage(with: destination)
      }
    }
  }
}

#Preview {
  LocarieView()
}
