//
//  BusinessDescriptionPage.swift
//  locarie
//
//  Created by qiuty on 28/05/2024.
//

import SwiftUI

struct BusinessDescriptionPage: View {
  var body: some View {
    VStack {
      NavigationBar("Create a business account")
      Spacer()
      Image("BusinessDescriptionImage")
      Text("Add your business on Locarie")
        .font(.custom(GlobalConstants.fontName, size: 20))
        .fontWeight(.bold)
      HStack(alignment: .top, spacing: 0) {
        Circle()
          .fill(LocarieColor.primary)
          .frame(size: Constants.dotSize)
          .padding(.top, 8)
          .padding(.trailing, 7)
        Text("Share What's On and connect with those who would love your business.")
          .frame(width: Constants.textWidth)
      }
      Spacer()
      NavigationLink {
        AddBusinessPage()
      } label: {
        StrokeButtonFormItem(title: "Next step").padding([.horizontal, .bottom])
      }
    }
  }
}

private enum Constants {
  static let dotSize: CGFloat = 6
  static let textWidth: CGFloat = 265
}

#Preview {
  BusinessDescriptionPage()
}
