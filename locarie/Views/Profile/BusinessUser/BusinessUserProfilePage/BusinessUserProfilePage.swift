//
//  BusinessUserProfilePage.swift
//  locarie
//
//  Created by qiuty on 07/01/2024.
//

@_spi(Experimental) import MapboxMaps
import SwiftUI

struct BusinessUserProfilePage: View {
  @State var screenSize: CGSize = .zero
  @State private var viewport: Viewport = .camera(
    center: .london, zoom: Constants.mapZoom
  )
  @State private var post = PostDto()
  @State private var currentDetent: BottomSheetDetent = Constants.mediumDetent

  @State private var presentingProfileDetail = false
  @State private var presentingProfileCover = false
  @State private var presentingPostCover = false
  @State private var presentingMyCover = false
  @State private var presentingDialog = false

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared
  @StateObject private var profileVM = ProfileGetViewModel()
  @StateObject private var postsVM = ListUserPostsViewModel()

  var body: some View {
    GeometryReader { proxy in
      ZStack(alignment: .bottom) {
        VStack(spacing: 0) {
          ZStack {
            mapView
            contentView
          }
          BottomTabView()
        }
        if presentingProfileCover {
          BusinessProfileCover(
            user: profileVM.dto,
            isPresenting: $presentingProfileCover
          )
        }
        if presentingPostCover {
          PostCover(post: post, tags: user.categories, isPresenting: $presentingPostCover)
        }
        if presentingDialog {
          dialogBackground
            .ignoresSafeArea(edges: .top)
        }
        VStack {
          if presentingDialog {
            ProfileEditDialog(isPresenting: $presentingDialog)
              .transition(.move(edge: .bottom))
          }
        }
      }
      .sheet(isPresented: $presentingMyCover) {
        VStack {
          Capsule().fill(LocarieColor.greyMedium)
            .frame(width: 48, height: 6)
          Label {
            Text("My Page")
          } icon: {
            Image("Person")
          }
          .padding(.top, 12)
          .padding(.bottom, 24)
          FollowAndLikeView()
        }
        .padding(.top, 8)
        .presentationDetents([.fraction(0.95)])
      }
      .onAppear {
        if cacheVM.isFirstLoggedIn() {
          withAnimation(.spring) {
            presentingDialog = true
          }
        }
        screenSize = proxy.size
        profileVM.getProfile(userId: userId)

        postsVM.getUserPosts(id: userId)
      }
      .onDisappear(perform: {
        presentingDialog = false
      })
      .onReceive(profileVM.$dto) { dto in
        viewport = .camera(center: dto.coordinate, zoom: Constants.mapZoom)
      }
    }
    .ignoresSafeArea(edges: .bottom)
  }

  private var user: UserDto {
    profileVM.dto
  }

  private var userId: Int64 {
    cacheVM.getUserId()
  }
}

private extension BusinessUserProfilePage {
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
    .gestureOptions(disabledAllGesturesOptions())
    .ornamentOptions(noScaleBarAndCompassOrnamentOptions(bottom: 540))
    .ignoresSafeArea(edges: .all)
    .onTapGesture {
      withAnimation(.spring) {
        currentDetent = Constants.bottomDetent
      }
    }
  }
}

private extension BusinessUserProfilePage {
  var contentView: some View {
    VStack(spacing: 0) {
      buttons
      Spacer()
      BottomSheet(
        topPosition: .right,
        detents: [Constants.bottomDetent, Constants.mediumDetent, .large],
        currentDetent: $currentDetent
      ) {
        Group {
          if case .loading = profileVM.state {
            skeleton
          } else {
            sheetContent
          }
        }
        .padding(.horizontal, 16)
      }
    }
  }

  var sheetContent: some View {
    VStack(alignment: .leading, spacing: 16) {
      BusinessProfileAvatarRow(
        user: user,
        presentingCover: $presentingProfileCover,
        presentingDetail: $presentingProfileDetail
      )
      ScrollViewReader { proxy in
        ScrollView {
          VStack(alignment: .leading, spacing: 16) {
            ProfileCategories(user).id(0)
            if presentingProfileDetail {
              ProfileDetail(user)
            }
            ProfilePostsCount(postsVM.posts)
            postList
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
        .scrollIndicators(.hidden)
      }
    }
  }

  @ViewBuilder
  var postList: some View {
    if postsVM.posts.isEmpty {
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
        ForEach(postsVM.posts.indices, id: \.self) { i in
          let p = postsVM.posts[i]
          VStack(spacing: 0) {
            PostCardView(p)
              .buttonStyle(.plain)
              .padding(.bottom, 16)
              .onTapGesture {
                post = p
                presentingPostCover = true
              }

            if i != postsVM.posts.count - 1 {
              Divider()
                .foregroundStyle(LocarieColor.greyMedium)
                .padding(.bottom, 16)
            }
          }
        }
      }
    }
  }

  @ViewBuilder
  var firstProfileImage: some View {
    Group {
      if user.profileImageUrls.isEmpty {
        DefaultBusinessImageView()
      } else {
        BusinessImageView(url: URL(string: user.profileImageUrls[0]))
      }
    }
    .onTapGesture {
      presentingProfileCover = true
    }
  }

  var buttons: some View {
    HStack {
      mineButton
      Spacer()
      ProfileEditButton()
      Spacer()
      settingsButton
    }
    .padding(.horizontal, 16)
  }

  var mineButton: some View {
    ZStack {
      Circle()
        .fill(.background)
        .frame(width: Constants.topButtonSize, height: Constants.topButtonSize)
      Image("Person")
        .resizable()
        .scaledToFit()
        .frame(width: Constants.topButtonIconSize, height: Constants.topButtonIconSize)
    }
    .onTapGesture {
      presentingMyCover = true
    }
  }

  var settingsButton: some View {
    NavigationLink(value: Router.Destination.settings) {
      Image("GearShape")
        .frame(width: Constants.topButtonSize, height: Constants.topButtonSize)
        .background(Circle().fill(.background))
    }
    .buttonStyle(.plain)
  }
}

private extension BusinessUserProfilePage {
  var dialogBackground: some View {
    Color
      .black
      .opacity(Constants.dialogBgOpacity)
      .onTapGesture {
        withAnimation(.spring) {
          presentingDialog = false
        }
      }
  }
}

private enum Constants {
  static let bottomDetent: BottomSheetDetent = .absoluteBottom(116)
  static let mediumDetent: BottomSheetDetent = .absoluteBottom(540)

  static let dialogBgOpacity: CGFloat = 0.2
  static let dialogAnimationDuration: CGFloat = 1

  static let mapZoom: CGFloat = 12
  static let buttonShadowRadius: CGFloat = 2.0

  static let topButtonSize: CGFloat = 40
  static let topButtonIconSize: CGFloat = 18
}

#Preview {
  BusinessUserProfilePage()
}
