//
//  BusinessBottomBar.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct BusinessBottomBar: View {
  var body: some View {
    ZStack(alignment: .top) {
      background
      HStack {
        favoriteButton
        Spacer()
        directionButton
      }
      .padding(.top, Constants.topPadding)
      .padding(.horizontal, Constants.hPadding)
    }
    .fontWeight(.semibold)
    .frame(height: Constants.height)
    .ignoresSafeArea(edges: .bottom)
  }

  private var favoriteButton: some View {
    Image(systemName: "bookmark")
      .resizable()
      .scaledToFit()
      .frame(height: Constants.iconSize)
  }

  private var directionButton: some View {
    Label("Direction", systemImage: "map")
      .padding(.horizontal, Constants.directionButtonHPadding)
      .frame(height: Constants.directionButtonHeight)
      .background(
        Capsule().stroke(.secondary)
      )
  }

  private var background: some View {
    UnevenRoundedRectangle(
      topLeadingRadius: Constants.cornerRadius,
      topTrailingRadius: Constants.cornerRadius
    )
    .fill(.background)
    .shadow(radius: Constants.shadowRadius)
  }
}

private enum Constants {
  static let height: CGFloat = 90
  static let topPadding: CGFloat = 15
  static let hPadding: CGFloat = 40
  static let iconSize: CGFloat = 28
  static let cornerRadius: CGFloat = 20
  static let shadowRadius: CGFloat = 2
  static let directionButtonHPadding: CGFloat = 40
  static let directionButtonHeight: CGFloat = 44
}

#Preview {
  ZStack(alignment: .bottom) {
    Color.pink
    BusinessBottomBar()
  }
  .ignoresSafeArea(edges: .bottom)
}
