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
      .foregroundStyle(Constants.color)
      .padding(.horizontal, 10)
      .padding(.vertical, 4)
      .background {
        Capsule().strokeBorder(Constants.color, style: .init(lineWidth: 1.5))
      }
  }
}

private enum Constants {
  static let color = Color(hex: 0x0E0E0E)
}

#Preview {
  ProfileBusinessCategoryView("Coffee")
}
