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
  
//  private let cacheVM = LocalCacheViewModel.shared
//  var body: some View {
//    let url = cacheVM.getAvatarUrl()
//    VStack(spacing: 10) {
//      HStack {
//        Spacer()
//        if !url.isEmpty {
//          KFImage(URL(string: url))
//            .placeholder { SkeletonView(64, 64, true) }
//            .resizable()
//            .frame(size: 64)
//            .clipShape(Circle())
//        } else {
//          defaultAvatar(size: 64, isBusiness: cacheVM.isBusinessUser())
//        }
//        Spacer()
//      }
//    }
//    .onReceive(NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification, object: nil)) { notification in
//      print(notification)
//    }
//  }

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
