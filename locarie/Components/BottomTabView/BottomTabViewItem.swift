//
//  BottomTabViewItem.swift
//  locarie
//
//  Created by qiuty on 2023/11/6.
//

import SwiftUI

struct BottomTabViewItem: View {
  @ObservedObject var viewRouter = BottomTabViewRouter.shared

  let page: Page
  let iconUrl: String
  let iconName: String
  let selectedIconName: String

  init(page: Page, iconUrl: String) {
    self.page = page
    self.iconUrl = iconUrl
    iconName = ""
    selectedIconName = ""
  }

  init(page: Page, iconName: String, selectedIconName: String = "") {
    self.page = page
    iconUrl = ""
    self.iconName = iconName
    self.selectedIconName = selectedIconName
      .isEmpty ? iconName : selectedIconName
  }

  var body: some View {
    icon
  }

  @ViewBuilder
  private var icon: some View {
    if iconUrl.isEmpty {
      Image(viewRouter.currentPage == page ? selectedIconName : iconName)
        .frame(width: Constants.size, height: Constants.size)
    } else {
      AsyncImageView(
        url: iconUrl, width: Constants.size, height: Constants.size
      ) { image in
        image.resizable()
          .scaledToFill()
          .clipShape(Circle())
          .frame(width: Constants.size, height: Constants.size)
      }
    }
  }
}

private enum Constants {
  static let size: CGFloat = 28
}
