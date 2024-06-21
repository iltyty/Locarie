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
      .foregroundStyle(LocarieColor.greyDark)
      .padding(.horizontal, 10)
      .padding(.vertical, 4)
      .background(Capsule().fill(LocarieColor.greyMedium))
  }
}

#Preview {
  ProfileBusinessCategoryView("Coffee")
}
