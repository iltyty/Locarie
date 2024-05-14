//
//  ProfileBusinessCategoryView.swift
//  locarie
//
//  Created by qiuty on 14/04/2024.
//

import SwiftUI

struct ProfileBusinessCategoryView: View {
  let category: String

  init(_ category: String) {
    self.category = category
  }

  var body: some View {
    Text(category)
      .font(.custom(GlobalConstants.fontName, size: 14))
      .padding()
      .frame(height: Constants.height)
      .background(Capsule().fill(LocarieColor.greyMedium))
  }
}

private enum Constants {
  static let height: CGFloat = 24
}

#Preview {
  ProfileBusinessCategoryView("Food")
}
