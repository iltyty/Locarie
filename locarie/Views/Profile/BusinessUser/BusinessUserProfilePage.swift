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
      }
    }
  }

  private var content: some View {
    ScrollView {
      profileImage
      profileContent
    }
    .scrollBounceBehavior(.basedOnSize)
  }
}

private extension BusinessUserProfilePage {
  var profileImage: some View {
    ZStack(alignment: .top) {
      Rectangle().fill(.thinMaterial)
      settingsButton
    }
    .frame(height: Constants.profileImageHeightFraction * screenHeight)
    .background(.thinMaterial)
  }

  var settingsButton: some View {
    HStack {
      Spacer()
      NavigationLink(value: Router.Destination.settings) {
        Image(systemName: "gearshape")
          .font(.system(size: Constants.settingsButtonIconSize))
          .padding(.trailing)
      }
      .buttonStyle(.plain)
    }
    .padding(.top, topSafeAreaHeight)
  }

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
    AvatarView(size: Constants.avatarSize)
  }

  var profileEditButton: some View {
    NavigationLink {
      BusinessUserProfileEditPage()
    } label: {
      Text("Edit profile")
        .foregroundStyle(Color.locariePrimary)
        .padding(Constants.settingsButtonTextPadding)
        .background(profileEditButtonBackground)
    }
  }

  var profileEditButtonBackground: some View {
    Capsule().stroke(Color.locariePrimary)
  }

  var businessNameAndCategory: some View {
    HStack {
      Text("Business name").font(.headline)
      Spacer()
      Text("Business category")
        .font(.callout)
        .foregroundStyle(.secondary)
    }
  }

  var businessBio: some View {
    Text("Go to Edit Profile to personalize your business profile.")
      .foregroundStyle(.secondary)
  }

  var location: some View {
    Label("Location", systemImage: "location")
  }

  var openingHours: some View {
    Label("Opening hours", systemImage: "clock")
  }

  var link: some View {
    Label("Link", systemImage: "link")
  }

  var phone: some View {
    Label("Phone", systemImage: "phone")
  }
}

private enum Constants {
  static let profileImageHeightFraction = 0.25
  static let settingsButtonIconSize = 24.0
  static let settingsButtonTextPadding = 10.0
  static let avatarSize = 64.0
  static let vSpacing = 24.0
}

#Preview {
  BusinessUserProfilePage()
    .environmentObject(Router.shared)
    .environmentObject(BottomTabViewRouter())
}
