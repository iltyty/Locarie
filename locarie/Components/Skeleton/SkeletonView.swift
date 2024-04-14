//
//  SkeletonView.swift
//  locarie
//
//  Created by qiuty on 12/04/2024.
//

import SwiftUI

struct SkeletonView: View {
  @State var circle: Bool

  let width, height: CGFloat

  init(_ width: CGFloat, _ height: CGFloat, _ circle: Bool = false) {
    self.width = width
    self.height = height
    self.circle = circle
  }

  var body: some View {
    Group {
      if circle {
        Circle().fill(Constants.fillColor)
      } else {
        RoundedRectangle(cornerRadius: Constants.cornerRadius).fill(Constants.fillColor)
      }
    }
    .frame(width: width, height: height)
  }
}

private enum Constants {
  static let cornerRadius: CGFloat = 10
  static let fillColor: Color = LocarieColor.lightGray
}

#Preview {
  VStack {
    SkeletonView(100, 100, true)
    SkeletonView(200, 20)
  }
}
