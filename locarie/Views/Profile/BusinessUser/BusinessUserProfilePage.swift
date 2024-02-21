//
//  BusinessUserProfilePage.swift
//  locarie
//
//  Created by qiuty on 07/01/2024.
//

@_spi(Experimental) import MapboxMaps
import SwiftUI

struct BusinessUserProfilePage: View {
  @State private var showingDetailProfile = false

  @State private var screenSize: CGSize = .zero
  @State private var viewport: Viewport = .camera(
    center: .london, zoom: Constants.mapZoom
  )

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared
  @StateObject private var postsVM = ListUserPostsViewModel()
  @StateObject private var profileVM = ProfileGetViewModel()

  var body: some View {
    GeometryReader { proxy in
      VStack {
        content
        BottomTabView()
      }
      .onAppear {
        screenSize = proxy.size
        postsVM.getUserPosts(id: cacheVM.getUserId())
        profileVM.getProfile(userId: cacheVM.getUserId())
      }
      .onReceive(profileVM.$dto) { dto in
        viewport = .camera(
          center: dto.coordinate,
          zoom: Constants.mapZoom
        )
      }
    }
    .ignoresSafeArea(edges: .bottom)
  }

  private var content: some View {
    ZStack {
      mapView
      contentView
    }
  }
}

private extension BusinessUserProfilePage {
  var mapView: some View {
    Map(viewport: $viewport) {
      MapViewAnnotation(coordinate: profileVM.dto.coordinate) {
        Image("map")
          .onTapGesture {
            viewport = .camera(
              center: profileVM.dto.coordinate,
              zoom: Constants.mapZoom
            )
          }
      }
    }
    .ignoresSafeArea(edges: .all)
  }
}

private extension BusinessUserProfilePage {
  var contentView: some View {
    VStack {
      buttons
      Spacer()
      BottomSheet(detents: [.medium, .fraction(0.67)]) {
        profile
      }
    }
  }

  var buttons: some View {
    ZStack {
      HStack {
        Spacer()
        profileEditButton
        Spacer()
      }
      settingsButton
    }
  }

  var profileEditButton: some View {
    NavigationLink(value: Router.Destination.userProfileEdit) {
      HStack {
        Image("EditIcon")
          .resizable()
          .scaledToFit()
          .frame(
            width: Constants.profileEditButtonIconSize,
            height: Constants.profileEditButtonIconSize
          )
        Text("Edit profile")
      }
      .padding(Constants.settingsButtonTextPadding)
      .background(profileEditButtonBackground)
    }
    .buttonStyle(.plain)
  }

  var profileEditButtonBackground: some View {
    Capsule()
      .fill(.background)
      .shadow(radius: Constants.buttonShadowRadius)
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
  }
}

private extension BusinessUserProfilePage {
  var profile: some View {
    VStack(alignment: .leading, spacing: Constants.vSpacing) {
      avatarRow
      categories
      businessBio
      if showingDetailProfile {
        detailProfile
      }
      numPostsTitle
      posts
    }
    .padding(.horizontal)
  }

  var avatarRow: some View {
    HStack {
      avatar
      businessName
      Spacer()
      detailButton
    }
  }

  var avatar: some View {
    AvatarView(
      imageUrl: cacheVM.getAvatarUrl(),
      size: Constants.avatarSize
    )
  }

  var businessName: some View {
    Text(profileVM.dto.businessName)
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
        ForEach(profileVM.dto.categories, id: \.self) { category in
          TagView(tag: category, isSelected: false)
        }
      }
    }
  }

  var detailProfile: some View {
    VStack(alignment: .leading, spacing: Constants.detailProfileVSpacing) {
      favoredBy
      location
      openingHours
      link
      phone
      Divider()
    }
  }

  var favoredBy: some View {
    Label("\(profileVM.dto.favoredByCount)", systemImage: "bookmark")
  }

  var businessBio: some View {
    var bio = profileVM.dto.introduction
    if bio.isEmpty {
      bio = "Go set up the profile!"
    }
    return Text(bio).foregroundStyle(.secondary).lineLimit(2)
  }

  var location: some View {
    Label {
      Text(profileVM.dto.address)
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
    let text = profileVM.dto.formattedBusinessHours
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
    let text = profileVM.dto.homepageUrl
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
    let text = profileVM.dto.phone
    text.isEmpty
      ? Text("Phone number").foregroundStyle(.secondary)
      : Text(text)
  }
}

private extension BusinessUserProfilePage {
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
          Text("\(postsVM.posts.count) ")
          Text("posts")
        }
      }
    }
    .fontWeight(.semibold)
  }

  var posts: some View {
    ForEach(postsVM.posts) { post in
      // - TODO: post card width
      PostCardView(post: post, width: 250)
    }
  }
}

private enum Constants {
  static let vSpacing: CGFloat = 16
  static let detailProfileVSpacing: CGFloat = 20

  static let mapZoom: CGFloat = 12
  static let buttonShadowRadius: CGFloat = 2.0

  static let profileEditButtonBorderColor: Color = .init(hex: 0xD9D9D9)
  static let profileEditButtonIconSize: CGFloat = 16
  static let profileImageHeightFraction = 0.25

  static let profileIconSize: CGFloat = 16

  static let settingsButtonIconPadding: CGFloat = 10
  static let settingsButtonIconSize: CGFloat = 24
  static let settingsButtonTextPadding: CGFloat = 10
  static let avatarSize: CGFloat = 72
}

#Preview {
  BusinessUserProfilePage()
}
