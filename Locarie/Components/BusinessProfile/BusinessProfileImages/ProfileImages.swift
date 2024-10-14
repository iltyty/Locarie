//
//  ProfileImages.swift
//  Locarie
//
//  Created by qiuty on 22/08/2024.
//

import Kingfisher
import SwiftUI

struct ProfileImages: View {
  let user: UserDto
  var amplified = false

  @Binding var profileCoverCurIndex: Int
  @Binding var presentingProfileCover: Bool

  var body: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 8) {
        HStack(spacing: 8) {
          ForEach(user.profileImageUrls.indices, id: \.self) { i in
            ZStack(alignment: .topTrailing) {
              KFImage(URL(string: user.profileImageUrls[i]))
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
              if amplified, i == 0 {
                DistanceView(user: user).padding(5)
              }
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
