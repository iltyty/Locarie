//
//  BackToMapButton.swift
//  locarie
//
//  Created by qiuty on 24/06/2024.
//

import SwiftUI

struct BackToMapButton: View {
  static let width: CGFloat = 82
  static let height: CGFloat = 40

  var body: some View {
    Image(systemName: "map")
      .resizable()
      .foregroundStyle(.white)
      .frame(width: 18, height: 18)
      .frame(width: BackToMapButton.width, height: BackToMapButton.height)
      .background { Capsule().fill(.black) }
  }
}

#Preview {
  BackToMapButton()
}
