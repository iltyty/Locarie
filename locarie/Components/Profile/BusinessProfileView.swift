//
//  BusinessProfileView.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct BusinessProfileView: View {
  let user: UserDto

  @Binding var isPresentingCover: Bool

  @State private var showingDetailProfile = false

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared
  @ObservedObject private var postsVM = ListUserPostsViewModel()

  var body: some View {
    VStack(alignment: .leading, spacing: Constants.vSpacing) {
      avatarRow
      ScrollView {
        VStack(alignment: .leading, spacing: Constants.vSpacing) {
          categories
          businessBio
          if showingDetailProfile {
            detailProfile
          }
          numPostsTitle
          posts
        }
      }
    }
    .onAppear {
      postsVM.getUserPosts(id: cacheVM.getUserId())
    }
  }
}

private extension BusinessProfileView {
  var avatarRow: some View {
    HStack {
      avatar
      businessName
      Spacer()
      detailButton
    }
  }

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
}

private extension BusinessProfileView {
  var businessBio: some View {
    var bio = user.introduction
    if bio.isEmpty {
      bio = "Go set up the profile!"
    }
    return Text(bio).foregroundStyle(.secondary).lineLimit(2)
  }
}

private extension BusinessProfileView {
  var detailProfile: some View {
    VStack(alignment: .leading, spacing: Constants.detailProfileVSpacing) {
      favoredBy
      address
      openingHours
      link
      phone
      Divider()
    }
  }
}

private extension BusinessProfileView {
  @ViewBuilder
  var numPostsTitle: some View {
    Group {
      if postsVM.posts.isEmpty {
        HStack(spacing: 0) {
          Text("No ").foregroundStyle(Color.locariePrimary)
          Text("post yet")
        }
      } else {
        HStack(spacing: 0) {
          Text("\(postsVM.posts.count) ").foregroundStyle(Color.locariePrimary)
          Text("posts")
        }
      }
    }
    .fontWeight(.semibold)
  }

  var posts: some View {
    ForEach(postsVM.posts) { post in
      PostCardView(post)
    }
  }
}

private extension BusinessProfileView {
  var businessName: some View {
    Text(user.businessName)
      .font(.headline)
      .fontWeight(.bold)
  }

  var detailButton: some View {
    Button {
      withAnimation(.spring) {
        showingDetailProfile.toggle()
      }
    } label: {
      Image(systemName: showingDetailProfile ? "chevron.up" : "chevron.down")
    }
    .buttonStyle(.plain)
  }

  var categories: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(user.categories, id: \.self) { category in
          TagView(tag: category, isSelected: false)
        }
      }
    }
  }

  var favoredBy: some View {
    Label("\(user.favoredByCount)", systemImage: "bookmark")
  }

  var address: some View {
    Label {
      addressText
    } icon: {
      Image("BlueMap")
        .resizable()
        .scaledToFit()
        .frame(
          width: Constants.profileIconSize,
          height: Constants.profileIconSize
        )
    }
  }

  @ViewBuilder
  var addressText: some View {
    let text = user.address
    text.isEmpty
      ? Text("Address").foregroundStyle(.secondary)
      : Text(text)
  }

  var openingHours: some View {
    Label {
      openingHoursText
    } icon: {
      Image(systemName: "clock")
    }
    .lineLimit(1)
  }

  @ViewBuilder
  var openingHoursText: some View {
    let text = user.formattedBusinessHours
    text.isEmpty
      ? Text("Opening hours").foregroundStyle(.secondary)
      : Text(text)
  }

  var link: some View {
    Label {
      linkText
    } icon: {
      Image(systemName: "link")
    }
  }

  @ViewBuilder
  var linkText: some View {
    let text = user.homepageUrl
    text.isEmpty
      ? Text("Link").foregroundStyle(.secondary)
      : Text(text)
  }

  var phone: some View {
    Label {
      phoneText
    } icon: {
      Image(systemName: "phone")
    }
  }

  @ViewBuilder
  var phoneText: some View {
    let text = user.phone
    text.isEmpty
      ? Text("Phone number").foregroundStyle(.secondary)
      : Text(text)
  }
}

private enum Constants {
  static let vSpacing: CGFloat = 16

  static let avatarSize: CGFloat = 72
  static let avatarIconSize: CGFloat = 12
  static let avatarIconBgSize: CGFloat = 24

  static let detailProfileVSpacing: CGFloat = 20

  static let profileImageHeightFraction = 0.25

  static let profileIconSize: CGFloat = 16
}
