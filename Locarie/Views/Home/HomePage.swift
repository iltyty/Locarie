//
//  HomePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

@_spi(Experimental) import MapboxMaps
import CoreLocation
import SwiftUI

struct HomePage: View {
  private let router = Router.shared

  @ObservedObject private var network = Network.shared
  @StateObject private var postVM = PostListNearbyAllViewModel(size: Constants.postPageSize)
  @StateObject private var userListVM = UserListViewModel(size: Constants.userPageSize)

  @State private var tabIndex = 0
  
  @State private var prePostIndex = 0
  @State private var preUserIndex = 0
  @State private var shouldFetchPost = false
  @State private var shouldFetchUser = false

  @State private var user = UserDto()
  @State private var post = PostDto()
  @State private var presentingProfileCover = false
  @State private var presentingPostCover = false

  @State private var bottomTabMinY: CGFloat = 0
  @State private var currentDetent: BottomSheetDetent = Constants.bottomDetent
  @State private var mapTouched = false
  @State private var searching = false
  @State private var viewport: Viewport = .camera(center: .london, zoom: 12)

  @Namespace private var tabBarID
  @Namespace private var tabBarNS
  
  private let postScrollViewCoordinateSpace = "postScrollView"
  private let userScrollViewCoordinateSpace = "userScrollView"

  var body: some View {
    ZStack {
      DynamicPostsMapView(
        viewport: $viewport,
        mapTouched: $mapTouched,
        postVM: postVM,
        userListVM: userListVM,
        shouldFetchPost: shouldFetchPost,
        shouldFetchUser: shouldFetchUser
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
        ImagesFullScreenCover(
          index: 0,
          imageUrls: post.imageUrls,
          isPresenting: $presentingPostCover
        )
      }
      if presentingProfileCover {
        ImagesFullScreenCover(
          index: 0,
          imageUrls: user.profileImageUrls,
          isPresenting: $presentingProfileCover
        )
      }
    }
    .ignoresSafeArea(edges: .bottom)
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
        VStack(spacing: 0) {
          HStack(spacing: 0) {
            Spacer()
            tabBuilder(text: "Latest", i: 0)
            Spacer()
            tabBuilder(text: "Places", i: 1)
            Spacer()
          }
          if tabIndex == 0 {
            latestTabContent
          } else {
            placesTabContent
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

  func tabBuilder(text: String, i: Int) -> some View {
    VStack(spacing: 14) {
      Text(text)
        .fontWeight(.bold)
        .foregroundStyle(tabIndex == i ? .black : LocarieColor.greyDark)
        .onTapGesture {
          tabIndex = i
        }
      Group {
        if tabIndex == i {
          Rectangle().fill(.black).matchedGeometryEffect(id: tabBarID, in: tabBarNS)
        } else {
          Color.clear
        }
      }
      .frame(width: 32, height: 2)
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
      ScrollView {
        VStack(spacing: 16) {
          PostCardView.skeleton
          PostCardView.skeleton
        }
        .padding([.top, .horizontal], 16)
      }
      .scrollIndicators(.hidden)
    } else {
      VStack(spacing: 0) {
        ScrollView {
          if postVM.posts.isEmpty {
            emptyPostList
          } else {
            // Bug: cannot use LazyVStack here due to a SwiftUI bug:
            // https://forums.developer.apple.com/forums/thread/746396
            // SwiftUI really sucks!
            VStack(spacing: 0) {
              ForEach(postVM.posts.indices, id: \.self) { i in
                PostCardView(
                  postVM.posts[i],
                  divider: true,
                  seeProfile: true,
                  bottomPadding: i == postVM.posts.count - 1 ? .large : .small,
                  onTapped: {
                    router.navigate(to: Router.BusinessHomeDestination.businessHome(
                      postVM.posts[i].user.id,
                      postVM.posts[i].user.location?.latitude ?? CLLocationCoordinate2D.london.latitude,
                      postVM.posts[i].user.location?.longitude ?? CLLocationCoordinate2D.london.longitude,
                      true)
                    )
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
                .id(i)
                .tint(.primary)
                .buttonStyle(.plain)
              }
            }
            .background {
              GeometryReader { proxy in
                Color.clear.preference(key: PostViewOffsetKey.self, value: -(proxy.frame(in: .named(postScrollViewCoordinateSpace)).origin.y - 16))
              }
            }
            .onPreferenceChange(PostViewOffsetKey.self) { offset in
              let i = Int(offset) / GlobalConstants.postCardHeight
              if i <= prePostIndex {
                prePostIndex = i
                return
              }
              prePostIndex = i
              let delta = postVM.posts.count - Constants.postFetchThreshold
              if delta <= 0 || i == delta || i == postVM.posts.count {
                shouldFetchPost.toggle()
              }
            }
            .padding(.top, 16)
          }
        }
        .coordinateSpace(name: postScrollViewCoordinateSpace)
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
      ScrollView {
        VStack(spacing: 16) {
          BusinessAvatarRow.skeleton
          BusinessAvatarRow.skeleton
        }
        .padding([.top, .horizontal], 16)
      }
      .scrollIndicators(.hidden)
    } else {
      ScrollView {
        VStack(alignment: .leading, spacing: 0) {
          Text("Nearest-Furthest")
            .fontWeight(.bold)
            .foregroundStyle(LocarieColor.greyDark)
            .padding([.leading, .top], 16)
          Group {
            if userListVM.businesses.isEmpty {
              emptyBusinessList
            } else {
              placeList
            }
          }
          SuggestPlace()
            .padding(.horizontal, 16)
            .padding(.bottom, BackToMapButton.height + 40)
        }
      }
      .coordinateSpace(name: userScrollViewCoordinateSpace)
      .scrollIndicators(.hidden)
    }
  }
  
  var placeList: some View {
    VStack(spacing: 0) {
      ForEach(userListVM.businesses.indices, id: \.self) { i in
        let user = userListVM.businesses[i]
        VStack(spacing: 0) {
          NavigationLink(value: Router.BusinessHomeDestination.businessHome(
            user.id,
            user.location?.latitude ?? CLLocationCoordinate2D.london.latitude,
            user.location?.longitude ?? CLLocationCoordinate2D.london.longitude,
            true
          )) { BusinessAvatarRow(user: user, isPresentingCover: $presentingProfileCover) }
            .buttonStyle(.plain)
            .tint(.primary)
            .padding(.bottom, 16)
          
          LocarieDivider().padding([.bottom, .horizontal], 16)
        }
      }
    }
    .background {
      GeometryReader { proxy in
        Color.clear.preference(key: UserViewOffsetKey.self, value: -(proxy.frame(in: .named(userScrollViewCoordinateSpace)).origin.y - 16))
      }
    }
    .onPreferenceChange(UserViewOffsetKey.self) { offset in
      let i = Int(offset) / GlobalConstants.userCardHeight
      if i <= preUserIndex {
        preUserIndex = i
        return
      }
      preUserIndex = i
      let delta = userListVM.businesses.count - Constants.userFetchThreshold
      if delta <= 0 || i == delta || i == userListVM.businesses.count {
        shouldFetchUser.toggle()
      }
    }
    .padding(.top, 16)
  }

  var emptyPostList: some View {
    VStack {
      Image("NoPost")
        .resizable()
        .scaledToFit()
        .frame(size: 72)
      Text("No post yet")
        .font(.custom(GlobalConstants.fontName, size: 14))
        .fontWeight(.bold)
    }
    .padding(.top, 45)
    .padding(.bottom, 16)
  }
  
  var emptyBusinessList: some View {
    VStack {
      Image("Business")
        .resizable()
        .scaledToFit()
        .frame(size: 72)
      Text("No business yet")
        .font(.custom(GlobalConstants.fontName, size: 14))
        .fontWeight(.bold)
    }
    .padding(.top, 45)
    .padding(.bottom, 16)
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

private extension HomePage {
  struct PostViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
  }

  struct UserViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
  }
}

private enum Constants {
  static let postPageSize = 10
  static let postFetchThreshold = 5

  static let userPageSize = 10
  static let userFetchThreshold = 5
  
  static let bottomDetent: BottomSheetDetent = .absoluteBottom(214)
}

#Preview {
//  HomePage()
  ScrollView {
    VStack {
      Text("test").lineLimit(2, reservesSpace: true).background(.red)
    }
  }
}
