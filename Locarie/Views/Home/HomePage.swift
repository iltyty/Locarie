//
//  HomePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

@_spi(Experimental) import MapboxMaps
import SwiftUI

struct HomePage: View {
  private let router = Router.shared

  @ObservedObject private var network = Network.shared
  @StateObject private var postVM = PostListNearbyAllViewModel()
  @StateObject private var userListVM = UserListViewModel()

  @State private var page: Page = .latest
  @State private var user = UserDto()
  @State private var post = PostDto()
  @State private var presentingProfileCover = false
  @State private var presentingPostCover = false

  @State private var bottomTabMinY: CGFloat = 0
  @State private var currentDetent: BottomSheetDetent = Constants.bottomDetent
  @State private var mapTouched = false
  @State private var searching = false
  @State private var selectedPost = PostDto()
  @State private var viewport: Viewport = .camera(center: .london, zoom: 12)

  @Namespace var namespace

  var body: some View {
    ZStack {
      DynamicPostsMapView(
        viewport: $viewport,
        mapTouched: $mapTouched,
        homePage: $page,
        postVM: postVM,
        userListVM: userListVM
      )
      contentView
      if currentDetent == .large {
        VStack {
          Spacer()
          BackToMapButton()
            .padding(.bottom, BottomTabConstants.height + 24)
            .onTapGesture {
              moveBottomSheet(to: Constants.bottomDetent)
            }
        }
      }
      VStack { // ensure zIndex of all views keep the same
        if searching {
          BusinessSearchView(searching: $searching)
        }
      }
      if presentingPostCover {
        PostCover(
          post: post,
          tags: user.categories,
          onAvatarTapped: {
            presentingPostCover = false
            router.navigate(to: Router.Int64Destination.businessHome(user.id, true))
          },
          isPresenting: $presentingPostCover
        )
      }
      if presentingProfileCover {
        BusinessProfileCover(
          user: user,
          onAvatarTapped: {
            presentingProfileCover = false
            router.navigate(to: Router.Int64Destination.businessHome(user.id, true))
          },
          isPresenting: $presentingProfileCover
        )
      }
    }
    .ignoresSafeArea(edges: .bottom)
    .onReceive(postVM.$posts) { posts in
      selectedPost = posts.first ?? PostDto()
    }
    .onChange(of: mapTouched) { _ in
      moveBottomSheet(to: Constants.bottomDetent)
    }
  }

  private func moveBottomSheet(to detent: BottomSheetDetent) {
    withAnimation(.spring) {
      currentDetent = detent
    }
  }
}

private extension HomePage {
  var contentView: some View {
    VStack(spacing: 0) {
      buttons.padding(.vertical, 8)
      BottomSheet(
        topPosition: .right,
        detents: [Constants.bottomDetent, .large],
        currentDetent: $currentDetent
      ) {
        Group {
          VStack(spacing: 0) {
            HStack(spacing: 0) {
              Spacer()
              latestTab
              Spacer()
              placesTab
              Spacer()
            }
            if page == .latest {
              latestTabContent
            } else {
              placesTabContent
            }
          }
        }
      } topContent: {
        CircleButton("Navigation")
          .padding(.trailing, 16)
          .onTapGesture {
            withViewportAnimation(.fly) {
              viewport = .followPuck(zoom: GlobalConstants.mapZoom)
            }
          }
      }
      BottomTabView().background {
        GeometryReader { proxy in
          Color.clear.task(id: proxy.frame(in: .global).minY) {
            bottomTabMinY = proxy.frame(in: .global).minY
          }
        }
      }
    }
  }

  var latestTab: some View {
    VStack(spacing: 12) {
      Text("Latest")
        .font(.custom(GlobalConstants.fontName, size: 18))
        .fontWeight(.bold)
        .foregroundStyle(page == .latest ? Color.black : LocarieColor.greyDark)
      Group {
        if page == .latest {
          Rectangle().fill(.black)
        } else {
          Color.clear
        }
      }
      .frame(width: 36, height: 2)
    }
    .onTapGesture {
      page = .latest
    }
  }

  var placesTab: some View {
    VStack(spacing: 4) {
      Text("Places")
        .font(.custom(GlobalConstants.fontName, size: 18))
        .fontWeight(.bold)
        .foregroundStyle(page == .places ? Color.black : LocarieColor.greyDark)
      Group {
        if page == .places {
          Rectangle().fill(.black)
        } else {
          Color.clear
        }
      }
      .frame(width: 36, height: 2)
    }
    .onTapGesture {
      page = .places
    }
  }

  @ViewBuilder
  var latestTabContent: some View {
    if !network.connected && postVM.posts.isEmpty {
      Text("No network connection")
        .fontWeight(.bold)
        .foregroundStyle(LocarieColor.greyDark)
        .padding([.top, .horizontal], 16)
    } else if postVM.state.isIdle() || postVM.state.isLoading() {
      VStack(spacing: 16) {
        PostCardView.skeleton
        PostCardView.skeleton
      }
      .padding([.top, .horizontal], 16)
    } else {
      VStack(spacing: 0) {
        ScrollView {
          if postVM.posts.isEmpty {
            emptyList
          } else {
            VStack(spacing: 0) {
              ForEach(postVM.posts.indices, id: \.self) { i in
                PostCardView(
                  postVM.posts[i],
                  divider: i != postVM.posts.count - 1,
                  onTapped: {
                    router.navigate(to: Router.Int64Destination.businessHome(postVM.posts[i].user.id, true))
                  },
                  onCoverTapped: {
                    post = postVM.posts[i]
                    user = post.user
                    presentingPostCover = true
                  },
                  onThumbnailTapped: {
                    post = postVM.posts[i]
                    user = post.user
                    presentingProfileCover = true
                  }
                )
                .padding(.top, i == 0 ? 8 : 0)
                .tint(.primary)
                .buttonStyle(.plain)
              }
            }
            .padding(.top, 16)
          }
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 16)
      }
    }
  }

  @ViewBuilder
  var placesTabContent: some View {
    if !network.connected && userListVM.businesses.isEmpty {
      Text("No network connection")
        .fontWeight(.bold)
        .foregroundStyle(LocarieColor.greyDark)
        .padding([.top, .horizontal], 16)
    } else if userListVM.state.isIdle() || userListVM.state.isLoading() {
      VStack(spacing: 16) {
        BusinessAvatarRow.skeleton
        BusinessAvatarRow.skeleton
      }
      .padding([.top, .leading], 16)
    } else {
      ScrollView {
        VStack(spacing: 20) {
          if userListVM.businesses.isEmpty {
            emptyList
          } else {
            VStack(spacing: 0) {
              ForEach(userListVM.businesses.indices, id: \.self) { i in
                let user = userListVM.businesses[i]
                VStack(spacing: 0) {
                  NavigationLink(value: Router.Int64Destination.businessHome(user.id, true)) {
                    BusinessAvatarRow(
                      user: user,
                      isPresentingCover: $presentingProfileCover
                    )
                  }
                  .buttonStyle(.plain)
                  .tint(.primary)
                  .padding(.bottom, i != userListVM.businesses.count - 1 ? 16 : BackToMapButton.height + 48)
                  if i != userListVM.businesses.count - 1 {
                    LocarieDivider().padding([.bottom, .horizontal], 16)
                  }
                }
              }
            }
          }
        }
        .padding(.top, 16)
      }
      .scrollIndicators(.hidden)
    }
  }

  var emptyList: some View {
    VStack {
      Image("NoBusiness")
      Text("No business yet")
        .font(.custom(GlobalConstants.fontName, size: 14))
        .fontWeight(.bold)
        .foregroundStyle(LocarieColor.greyDark)
    }
    .padding(.top, 45)
  }

  var buttons: some View {
    HStack(spacing: 0) {
      locarieIcon
      Spacer()
      searchIcon.padding(.horizontal, 16)
      NavigationLink(value: Router.Destination.favorite) {
        CircleButton("Bookmark.Fill")
      }
      .buttonStyle(.plain)
    }
    .fontWeight(.semibold)
    .padding(.horizontal, 16)
  }

  var locarieIcon: some View {
    Image("LocarieIcon")
      .resizable()
      .scaledToFit()
      .frame(size: 40)
      .clipShape(RoundedRectangle(cornerRadius: 4))
      .shadow(radius: 2)
      .onTapGesture {
        moveBottomSheet(to: .medium)
      }
  }

  var searchIcon: some View {
    CircleButton("MagnifyingGlass")
      .onTapGesture {
        withAnimation {
          searching.toggle()
        }
      }
  }
}

extension HomePage {
  enum Page {
    case latest, places
  }
}

private enum Constants {
  static let bottomDetent: BottomSheetDetent = .absoluteBottom(208)
}

#Preview {
  HomePage()
}
