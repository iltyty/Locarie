//
//  BottomTabView.swift
//  locarie
//
//  Created by qiuty on 2023/11/5.
//

import SwiftUI

private enum Constants {
  static let height: CGFloat = 60
  static let iconSize: CGFloat = 25
  static let horizontalPadding: CGFloat = 40
}

struct BottomTabView: View {
  @ObservedObject var viewRouter = BottomTabViewRouter.shared

  var body: some View {
    HStack {
      BottomTabViewItem(
        page: .home,
        iconName: "location"
      )
      .imageScale(.large)
      Spacer()
      BottomTabViewItem(
        page: .favorite,
        iconName: "bookmark"
      )
      .imageScale(.large)
      Spacer()
      BottomTabViewItem(
        page: .new,
        iconName: "plus.app"
      )
      .imageScale(.large)
      Spacer()
      BottomTabViewItem(
        page: .message,
        iconName: "message"
      ).imageScale(.large)
      Spacer()
      BottomTabViewItem(
        page: .profile,
        iconName: "person"
      )
      .imageScale(.large)
    }
    .frame(height: Constants.height)
    .padding(.horizontal, Constants.horizontalPadding)
    .background(.regularMaterial)
  }
}

#Preview {
  ZStack {
    Color.blue
    BottomTabView()
  }
}
