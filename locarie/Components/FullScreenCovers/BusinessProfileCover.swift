//
//  BusinessProfileCover.swift
//  locarie
//
//  Created by qiuty on 21/02/2024.
//

import SwiftUI

struct BusinessProfileCover: View {
  let user: UserDto
  @Binding var isPresenting: Bool

  var body: some View {
    VStack(alignment: .leading) {
      coverTop
      Spacer()
      profileImages
      coverBottom
      Spacer()
    }
    .padding(.horizontal)
    .background(.thickMaterial.opacity(CoverCommonConstants.backgroundOpacity))
    .contentShape(Rectangle())
  }
}

private extension BusinessProfileCover {
  var coverTop: some View {
    CoverTopView(user: user, isPresenting: $isPresenting)
  }

  var blank: some View {
    Color
      .clear
      .contentShape(Rectangle())
      .onTapGesture {
        withAnimation(.spring) {
          isPresenting = false
        }
      }
  }

  var profileImages: some View {
    Banner(
      urls: user.profileImageUrls,
      width: 250,
      height: 200,
      rounded: true
    )
    .padding(.bottom)
  }

  var coverBottom: some View {
    VStack(alignment: .leading, spacing: Constants.vSpacing) {
      categories
      address
      openUntil
    }
  }

  var categories: some View {
    HStack {
      ForEach(user.categories, id: \.self) { category in
        TagView(tag: category)
      }
    }
  }

  var address: some View {
    Label(user.address, systemImage: "map")
  }

  var openUntil: some View {
    Label(user.openUtil, systemImage: "clock")
  }
}

private enum Constants {
  static let vSpacing = 15.0
}
