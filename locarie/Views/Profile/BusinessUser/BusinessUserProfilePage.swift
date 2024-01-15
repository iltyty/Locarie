//
//  BusinessUserProfilePage.swift
//  locarie
//
//  Created by qiuty on 07/01/2024.
//

import SwiftUI

struct BusinessUserProfilePage: View {
  @State private var screenHeight = 0.0
  @State private var topSafeAreaHeight = 0.0

  @ObservedObject private var cacheViewModel = LocalCacheViewModel.shared
  @StateObject private var profileViewModel = ProfileGetViewModel()

  var body: some View {
    GeometryReader { proxy in
      VStack {
        content
        BottomTabView()
      }
      .ignoresSafeArea(edges: .top)
      .onAppear {
        screenHeight = proxy.size.height
        topSafeAreaHeight = proxy.safeAreaInsets.top
        profileViewModel.getProfile(userId: cacheViewModel.getUserId())
      }
    }
  }

  private var content: some View {
    ScrollView {
      profileImages
      profileContent
    }
    .scrollBounceBehavior(.basedOnSize)
  }
}

private extension BusinessUserProfilePage {
  var profileImages: some View {
    ZStack(alignment: .top) {
      if profileViewModel.dto.profileImageUrls.isEmpty {
        rectangle
      } else {
        banner
      }
      settingsButton
    }
  }

  var banner: some View {
    Banner(
      urls: profileViewModel.dto.profileImageUrls,
      height: Constants.profileImageHeightFraction * screenHeight
    )
  }

  var rectangle: some View {
    Rectangle().fill(.thinMaterial)
      .frame(height: Constants.profileImageHeightFraction * screenHeight)
  }

  var settingsButton: some View {
    HStack {
      Spacer()
      NavigationLink(value: Router.Destination.settings) {
        Image(systemName: "gearshape")
          .font(.system(size: Constants.settingsButtonIconSize))
          .padding(Constants.settingsButtonIconPadding)
          .background(Circle().fill(.white))
          .padding(.trailing)
      }
      .buttonStyle(.plain)
    }
    .padding(.top, topSafeAreaHeight)
  }
}

private extension BusinessUserProfilePage {
  var profileContent: some View {
    VStack(alignment: .leading, spacing: Constants.vSpacing) {
      avatarAndProfileEditButton
      businessNameAndCategory
      businessBio
      Divider()
      location
      openingHours
      link
      phone
      Divider()
    }
    .padding()
  }

  var avatarAndProfileEditButton: some View {
    HStack {
      avatar
      Spacer()
      profileEditButton
    }
  }

  var avatar: some View {
    AvatarView(
      imageUrl: cacheViewModel.getAvatarUrl(),
      size: Constants.avatarSize
    )
  }

  var profileEditButton: some View {
    NavigationLink(value: Router.Destination.userProfileEdit) {
      Text("Edit profile")
        .foregroundStyle(Color.locariePrimary)
        .padding(Constants.settingsButtonTextPadding)
        .background(profileEditButtonBackground)
    }
  }

  var profileEditButtonBackground: some View {
    Capsule().stroke(Color.locariePrimary)
  }

  @ViewBuilder
  var businessNameAndCategory: some View {
    let businessName = profileViewModel.dto.businessName
    let category = profileViewModel.dto.category
    HStack {
      Text(businessName).font(.headline)
      Spacer()
      Text(category)
        .font(.callout)
        .foregroundStyle(.secondary)
    }
  }

  var businessBio: some View {
    var bio = profileViewModel.dto.introduction
    if bio.isEmpty {
      bio = "Go to Edit Profile to personalize your business profile."
    }
    return Text(bio).foregroundStyle(.secondary).lineLimit(2)
  }

  var location: some View {
    Label(profileViewModel.dto.address, systemImage: "location")
  }

  var openingHours: some View {
    Label(
      profileViewModel.dto.formattedBusinessHours,
      systemImage: "clock"
    )
    .lineLimit(1)
  }

  var link: some View {
    Label(profileViewModel.dto.homepageUrl, systemImage: "link")
  }

  var phone: some View {
    Label(profileViewModel.dto.phone, systemImage: "phone")
  }
}

private enum Constants {
  static let profileImageHeightFraction = 0.25
  static let settingsButtonIconPadding = 10.0
  static let settingsButtonIconSize = 24.0
  static let settingsButtonTextPadding = 10.0
  static let avatarSize = 64.0
  static let vSpacing = 24.0
}

#Preview {
  BusinessUserProfilePage()
}
