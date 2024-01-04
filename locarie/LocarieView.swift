//
//  LocarieView.swift
//  locarie
//
//  Created by qiuty on 2023/10/30.
//

import CoreLocation
import SwiftUI

struct LocarieView: View {
  @EnvironmentObject var viewRouter: BottomTabViewRouter

  var body: some View {
    NavigationStack {
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
}

#Preview {
  LocarieView()
    .environmentObject(BottomTabViewRouter())
    .environmentObject(MessageViewModel())
    .environmentObject(LocalCacheViewModel())
}
