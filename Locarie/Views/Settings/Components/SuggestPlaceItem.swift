//
//  SuggestPlaceItem.swift
//  Locarie
//
//  Created by qiu on 2024/11/19.
//

import SwiftUI

struct SuggestPlaceItem: View {
  var body: some View {
    Link(destination: URL(string: Constants.url)!) {
      VStack(spacing: 0) {
        HStack {
          Text("Suggest a place")
            .foregroundStyle(LocarieColor.primary)
          Spacer()
          Image("Business")
            .resizable()
            .scaledToFit()
            .frame(size: 22)
        }
        .contentShape(Rectangle())
        .padding(.vertical, 20)
        LocarieDivider()
      }
      .padding(.horizontal, 16)
      .background(.white)
    }
    .buttonStyle(.plain)
  }
}

private struct Constants {
  static let url = "https://www.locarie.com/suggest-a-place"
}

#Preview {
  SuggestPlaceItem()
}
