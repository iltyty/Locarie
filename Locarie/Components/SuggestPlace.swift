//
//  SuggestPlace.swift
//  Locarie
//
//  Created by qiu on 2024/11/19.
//

import SwiftUI

struct SuggestPlace: View {
  var body: some View {
    Link(destination: URL(string: Constants.url)!) {
      HStack {
        Text("Suggest a place")
          .foregroundStyle(LocarieColor.primary)
          .fontWeight(.bold)
        Spacer()
        Image("Business")
          .resizable()
          .scaledToFit()
          .frame(size: 22)
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
      .background {
        Capsule().fill(LocarieColor.lightYellow)
      }
    }
  }
}

private struct Constants {
  static let url = "https://www.locarie.com/suggest-a-place"
}

#Preview {
  SuggestPlace()
}
