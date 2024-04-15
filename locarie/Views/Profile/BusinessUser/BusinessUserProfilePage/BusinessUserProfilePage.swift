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
        VStack {
          content
          BottomTabView()
        }
        if presentingProfileCover {
          BusinessProfileCover(
            user: profileVM.dto,
            isPresenting: $presentingProfileCover
          )
        }
        if presentingPostCover {
          PostCover(post: post, isPresenting: $presentingPostCover)
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
        Image("DefaultBusinessMapMarker")
          .onTapGesture {
            viewport = .camera(
              center: user.coordinate,
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
      BottomSheet(topPosition: .right, detents: [.medium, .fraction(0.67)]) {
        if case .loading = profileVM.state {
          skeleton
        } else {
          sheetContent
        }
      } topContent: {
        firstProfileImage
      }
    }
  }

  var sheetContent: some View {
    VStack(alignment: .leading, spacing: Constants.vSpacing) {
      BusinessProfileAvatarRow(
        user: user,
        isPresentingCover: $presentingProfileCover,
        isPresentingDetail: $presentingProfileDetail
      )
      ProfileCategories(user)
      ScrollView {
        VStack(alignment: .leading, spacing: Constants.vSpacing) {
          ProfileBio(user)
          if presentingProfileDetail {
            ProfileDetail(user)
          }
          ProfilePostsCount(postsVM.posts)
          ForEach(postsVM.posts) { p in
            PostCardView(p)
              .onTapGesture {
                post = p
                presentingPostCover = true
              }
          }
        }
      }
    }
  }

  @ViewBuilder
  var firstProfileImage: some View {
    if user.profileImageUrls.isEmpty {
      Image("DefaultImage")
        .resizable()
        .scaledToFit()
        .frame(width: 28, height: 28)
        .frame(width: 72, height: 72)
        .background(RoundedRectangle(cornerRadius: 16).fill(LocarieColor.greyMedium).shadow(radius: 2))
    } else {
      AsyncImage(url: URL(string: user.profileImageUrls[0])) { image in
        image.resizable()
          .scaledToFit()
          .frame(width: 72, height: 72)
      } placeholder: {
        RoundedRectangle(cornerRadius: 16).fill(LocarieColor.greyMedium).shadow(radius: 2)
      }
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
    .padding(.horizontal)
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
      Image(systemName: "gearshape")
        .font(.system(size: Constants.topButtonIconSize))
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
  static let vSpacing: CGFloat = 16

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
