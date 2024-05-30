//
//  NavigationButton.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import SwiftUI

struct NavigationButton: View {
  var body: some View {
    Image("Navigation")
      .resizable()
      .scaledToFill()
      .shadow(radius: Constants.shadowRadius)
      .frame(width: Constants.size, height: Constants.size)
  }
}

private enum Constants {
  static let size: CGFloat = 48
  static let shadowRadius: CGFloat = 2
}

#Preview {
  ZStack {
    Color.pink
    NavigationButton()
  }
}
