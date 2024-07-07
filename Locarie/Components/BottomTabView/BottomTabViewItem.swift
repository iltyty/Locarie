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
  let iconName: String
  let selectedIconName: String

  init(page: Page, iconName: String, selectedIconName: String = "") {
    self.page = page
    self.iconName = iconName
    self.selectedIconName = selectedIconName
      .isEmpty ? iconName : selectedIconName
  }

  var body: some View {
    Image(viewRouter.currentPage == page ? selectedIconName : iconName)
      .frame(size: Constants.size)
  }
}

private enum Constants {
  static let size: CGFloat = 28
}
