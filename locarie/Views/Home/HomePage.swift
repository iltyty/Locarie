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

  @State private var currentDetent: BottomSheetDetent = Constants.bottomDetent
  @State private var mapTouched = false
  @State private var scrollId: Int64? = nil
  @State private var searching = false
  @State private var selectedPost = PostDto()
  @State private var viewport: Viewport =
    .followPuck(zoom: 11)

  @Namespace var namespace

  var body: some View {
    ZStack {
      DynamicPostsMapView(
        viewport: $viewport,
        mapTouched: $mapTouched,
        postVM: postVM
      )
      contentView
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
            router.navigate(to: Router.Int64Destination.businessHome(user.id))
          },
          isPresenting: $presentingPostCover
        )
      }
      if presentingProfileCover {
        BusinessProfileCover(
          user: user,
          onAvatarTapped: {
            presentingProfileCover = false
            router.navigate(to: Router.Int64Destination.businessHome(user.id))
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
      buttons
      BottomSheet(
        topPosition: .right,
        detents: [Constants.bottomDetent, .large],
        currentDetent: $currentDetent
      ) {
        Group {
          if case .loading = postVM.state {
            VStack {
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
        CircleButton(name: "Navigation")
          .padding(.trailing, 16)
          .onTapGesture {
            withViewportAnimation(.fly) {
              viewport = .followPuck(zoom: GlobalConstants.mapZoom)
            }
          }
      }
      BottomTabView()
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
                NavigationLink(value: Router.Int64Destination.businessHome(postVM.posts[i].user.id)) {
                  PostCardView(
                    postVM.posts[i],
                    divider: i != postVM.posts.count - 1,
                    onFullscreenTapped: {
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
                }
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
    HStack {
      locarieIcon
      Spacer()
      searchIcon
      NavigationLink(value: Router.Destination.favorite) {
        CircleButton(name: "Bookmark.Fill")
      }
      .buttonStyle(.plain)
    }
    .fontWeight(.semibold)
    .padding(.horizontal, 16)
    .padding(.bottom, 8)
  }

  var locarieIcon: some View {
    Image("LocarieIcon")
      .resizable()
      .scaledToFit()
      .frame(width: 40, height: 40)
      .clipShape(RoundedRectangle(cornerRadius: 4))
      .onTapGesture {
        moveBottomSheet(to: .medium)
      }
  }

  var searchIcon: some View {
    CircleButton(name: "MagnifyingGlass")
      .onTapGesture {
        withAnimation {
          searching.toggle()
        }
      }
  }
}

private enum Constants {
  static let bottomDetent: BottomSheetDetent = .absoluteBottom(205)
}

#Preview {
  HomePage()
}
