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

  @StateObject private var postVM = PostListNearbyAllViewModel()

  @State private var user = UserDto()
  @State private var post = PostDto()
  @State private var presentingProfileCover = false
  @State private var presentingPostCover = false

  @State private var bottomTabMinY: CGFloat = 0
  @State private var currentDetent: BottomSheetDetent = Constants.bottomDetent
  @State private var mapTouched = false
  @State private var scrollId: Int64? = nil
  @State private var searching = false
  @State private var selectedPost = PostDto()
  @State private var viewport: Viewport = .camera(center: .london, zoom: 11)

  @Namespace var namespace

  var body: some View {
    ZStack {
      DynamicPostsMapView(
        viewport: $viewport,
        mapTouched: $mapTouched,
        postVM: postVM
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
    .onChange(of: currentDetent) { _ in
      scrollId = 0
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
          if postVM.state.isIdle() || postVM.state.isLoading() {
            VStack(spacing: 16) {
              PostCardView.skeleton
              PostCardView.skeleton
            }
          } else {
            postList
          }
        }
        .allowsHitTesting(currentDetent != Constants.bottomDetent)
        .padding(.horizontal, 16)
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

  var postList: some View {
    ScrollViewReader { proxy in
      ScrollView {
        VStack(spacing: 20) {
          Text("Explore")
            .id(-1)
            .font(.custom(GlobalConstants.fontName, size: 18))
            .fontWeight(.bold)
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
                .id(i)
                .tint(.primary)
                .buttonStyle(.plain)
              }
            }
          }
        }
        .onChange(of: scrollId) { _ in
          proxy.scrollTo(0)
          scrollId = 1
        }
      }
    }
    .scrollIndicators(.hidden)
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

private enum Constants {
  static let bottomDetent: BottomSheetDetent = .absoluteBottom(208)
}

#Preview {
  HomePage()
}
