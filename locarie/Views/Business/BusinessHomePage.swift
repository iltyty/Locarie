//
//  BusinessHomePage.swift
//  locarie
//
//  Created by qiuty on 2023/11/8.
//

import SwiftUI
@_spi(Experimental) import MapboxMaps

struct BusinessHomePage: View {
  let uid: Int64
  let locationManager = LocationManager()

  @State private var viewport: Viewport = .camera(
    center: .london,
    zoom: Constants.mapZoom
  )

  @State private var post = PostDto()
  @State private var currentDetent: BottomSheetDetent = Constants.mediumDetent

  @State private var presentingProfileDetail = false
  @State private var presentingPostCover = false
  @State private var presentingProfileCover = false

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared
  @StateObject private var profileVM = ProfileGetViewModel()
  @StateObject private var listUserPostsVM = ListUserPostsViewModel()
  @StateObject private var favoritePostVM = FavoritePostViewModel()

  @Environment(\.dismiss) var dismiss

  var body: some View {
    GeometryReader { _ in
      ZStack(alignment: .top) {
        mapView
        VStack(spacing: 0) {
          topContent
            .padding(.bottom, 8)
            .padding(.horizontal, 16)
          Spacer()
          bottomContent
          BusinessBottomBar(businessId: uid, location: user.location).background(.background)
        }
        if presentingPostCover {
          PostCover(post: post, tags: user.categories, isPresenting: $presentingPostCover)
        }
        if presentingProfileCover {
          BusinessProfileCover(user: user, isPresenting: $presentingProfileCover)
        }
      }
    }
    .ignoresSafeArea(edges: .bottom)
    .onAppear {
      profileVM.getProfile(userId: uid)
      listUserPostsVM.getUserPosts(id: uid)
    }
    .onReceive(profileVM.$dto) { dto in
      viewport = .camera(center: dto.coordinate, zoom: Constants.mapZoom)
    }
  }

  private var user: UserDto {
    profileVM.dto
  }
}

private extension BusinessHomePage {
  var mapView: some View {
    Map(viewport: $viewport) {
      MapViewAnnotation(coordinate: profileVM.dto.coordinate) {
        BusinessMapAvatar(url: profileVM.dto.avatarUrl)
          .onTapGesture {
            viewport = .camera(
              center: user.coordinate,
              zoom: Constants.mapZoom
            )
          }
      }
    }
    .ornamentOptions(noScaleBarAndCompassOrnamentOptions(bottom: 590))
    .ignoresSafeArea(edges: .all)
  }

  var topContent: some View {
    HStack(spacing: 10) {
      CircleButton(systemName: "chevron.backward").onTapGesture {
        dismiss()
      }
      Spacer()
      CircleButton(name: "ShareIcon")
      CircleButton(systemName: "ellipsis")
    }
  }

  var bottomContent: some View {
    BottomSheet(
      topPosition: .right,
      detents: [Constants.bottomDetent, Constants.mediumDetent, .large],
      currentDetent: $currentDetent
    ) {
      VStack(alignment: .leading) {
        if case .loading = profileVM.state {
          skeleton
        } else {
          BusinessHomeAvatarRow(
            user: user,
            hasUpdates: updatedIn24Hours,
            presentingCover: $presentingProfileCover,
            presentingDetail: $presentingProfileDetail
          )
        }
        ScrollViewReader { proxy in
          ScrollView {
            VStack(alignment: .leading, spacing: Constants.vSpacing) {
              if case .loading = profileVM.state {
                EmptyView()
              } else {
                ProfileCategories(user).id(0)
                if presentingProfileDetail {
                  ProfileDetail(user)
                }
              }
              if case .loading = listUserPostsVM.state {
                PostCardView.skeleton
              } else {
                ProfilePostsCount(listUserPostsVM.posts)
                postList
              }
            }
            .onChange(of: currentDetent) { _ in
              proxy.scrollTo(0)
            }
            .onChange(of: presentingProfileDetail) { presenting in
              if presenting {
                proxy.scrollTo(0)
              }
            }
          }
        }
        .scrollIndicators(.hidden)
      }
      .padding(.horizontal, 16)
    }
  }

  @ViewBuilder
  var postList: some View {
    if listUserPostsVM.posts.isEmpty {
      HStack {
        Spacer()
        VStack {
          Image("NoPost").padding(.top, 40)
          Text("No post yet")
            .font(.custom(GlobalConstants.fontName, size: 14))
            .fontWeight(.bold)
        }
        Spacer()
      }
    } else {
      VStack(spacing: 0) {
        ForEach(listUserPostsVM.posts.indices, id: \.self) { i in
          let p = listUserPostsVM.posts[i]
          VStack {
            PostCardView(p)
              .buttonStyle(.plain)
              .padding(.bottom, 16)
              .onTapGesture {
                post = p
                presentingPostCover = true
              }

            if i != listUserPostsVM.posts.count - 1 {
              Divider()
                .foregroundStyle(LocarieColor.greyMedium)
                .padding(.bottom, 16)
            }
          }
        }
      }
    }
  }

  var updatedIn24Hours: Bool {
    !listUserPostsVM.posts.isEmpty &&
      Date().timeIntervalSince(listUserPostsVM.posts[0].time) < 86400
  }
}

private extension BusinessHomePage {
  func toggleShowingBusinessProfileCover() {
    withAnimation(.spring) {
      presentingProfileCover.toggle()
    }
  }

  func toggleShowingPostContentCover() {
    withAnimation(.spring) {
      presentingPostCover.toggle()
    }
  }
}

private extension BusinessHomePage {
  var skeleton: some View {
    VStack(alignment: .leading) {
      HStack {
        RoundedAvatarSkeletonView()
        VStack(alignment: .leading) {
          SkeletonView(84, 14)
          SkeletonView(146, 10)
        }
        Spacer()
      }
      HStack {
        SkeletonView(68, 10)
        SkeletonView(68, 10)
        Spacer()
      }
      SkeletonView(48, 10)
    }
  }
}

private enum Constants {
  static let bottomDetent: BottomSheetDetent = .absoluteBottom(112)
  static let mediumDetent: BottomSheetDetent = .absoluteBottom(540)
  static let vSpacing: CGFloat = 15
  static let mapZoom: CGFloat = 12
}

#Preview {
  BusinessHomePage(uid: 2)
}
