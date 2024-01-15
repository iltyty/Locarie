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

  var body: some View {
    Image(systemName: iconName)
      .onTapGesture {
        viewRouter.currentPage = page
      }
      .foregroundStyle(viewRouter.currentPage == page ? .blue : .gray)
  }
}

#Preview {
  BottomTabViewItem(
    page: .home,
    iconName: "bookmark"
  )
}
