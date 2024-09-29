//
//  ProfileImages.swift
//  Locarie
//
//  Created by qiuty on 22/08/2024.
//

import Kingfisher
import SwiftUI

struct ProfileImages: View {
  var amplified = false
  let urls: [String]

  @Binding var profileCoverCurIndex: Int
  @Binding var presentingProfileCover: Bool

  var body: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 8) {
        HStack(spacing: 8) {
          ForEach(urls.indices, id: \.self) { i in
            KFImage(URL(string: urls[i]))
              .placeholder {
                DefaultBusinessImageView(width: width, height: height)
              }
              .resizable()
              .scaledToFill()
              .frame(width: width, height: height)
              .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
              .onTapGesture {
                profileCoverCurIndex = i
                presentingProfileCover = true
              }
          }
        }
      }
      .padding(.horizontal, 16)
    }
    .scrollIndicators(.hidden)
  }

  private var width: CGFloat {
    amplified ? 267 : 48
  }

  private var height: CGFloat {
    amplified ? 200 : 48
  }

  private var aspectRatio: CGFloat {
    amplified ? 4.0 / 3 : 1
  }
}

private enum Constants {
  static let maxImageCount = 9
  static let cornerRadius: CGFloat = 16
}
