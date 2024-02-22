//
//  ProfileAvatarRow.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct ProfileAvatarRow: View {
  let user: UserDto
  @Binding var isPresentingCover: Bool
  @Binding var isPresentingDetail: Bool

  @ObservedObject var cacheVM = LocalCacheViewModel.shared

  init(
    _ user: UserDto,
    isPresentingCover: Binding<Bool>,
    isPresentingDetail: Binding<Bool>
  ) {
    self.user = user
    _isPresentingCover = isPresentingCover
    _isPresentingDetail = isPresentingDetail
  }

  var body: some View {
    HStack {
      avatar
      businessName
      Spacer()
      detailButton
    }
  }
}

private extension ProfileAvatarRow {
  var avatar: some View {
    ZStack(alignment: .bottomTrailing) {
      AvatarView(
        imageUrl: cacheVM.getAvatarUrl(),
        size: Constants.avatarSize
      )
      avatarEditIcon
    }
  }

  var avatarEditIcon: some View {
    Circle()
      .fill(.background)
      .stroke(.secondary)
      .frame(
        width: Constants.avatarIconBgSize,
        height: Constants.avatarIconBgSize
      )
      .overlay {
        Image("BlueEditIcon")
          .resizable()
          .scaledToFill()
          .frame(
            width: Constants.avatarIconSize,
            height: Constants.avatarIconSize
          )
      }
      .onTapGesture {
        withAnimation(.spring) {
          isPresentingCover = true
        }
      }
  }

  var businessName: some View {
    Text(user.businessName)
      .font(.headline)
      .fontWeight(.bold)
  }

  var detailButton: some View {
    Button {
      withAnimation(.spring) {
        isPresentingDetail.toggle()
      }
    } label: {
      Image(systemName: isPresentingDetail ? "chevron.up" : "chevron.down")
    }
    .buttonStyle(.plain)
  }
}

private enum Constants {
  static let avatarSize: CGFloat = 72
  static let avatarIconSize: CGFloat = 12
  static let avatarIconBgSize: CGFloat = 24
}
