//
//  HomePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import BottomSheet
import MapKit
import SwiftUI

struct HomePage: View {
  @State var screenSize: CGSize = .zero

  @StateObject private var viewModel = PostListNearbyViewModel()
  @StateObject private var locationManager = LocationManager()

  @State private var mapRegion = MKCoordinateRegion(
    center: CLLocationCoordinate2D.CP,
    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.1)
  )
  @State private var bottomSheetPosition = BottomSheetPosition.absoluteTop(300)
  @State private var topSafeAreaHeight: CGFloat = 0
  @State private var selectedTag: String = ""

  var body: some View {
    GeometryReader { proxy in
      VStack(spacing: 0) {
        content
        BottomTabView()
      }
      .onAppear {
        topSafeAreaHeight = proxy.safeAreaInsets.top
      }
    }
    .onReceive(locationManager.$location) { location in
      getNearbyPosts(withLocation: location)
    }
  }
}

private extension HomePage {
  var content: some View {
    ZStack(alignment: .top) {
      mapView
      contentView
    }
  }

  var mapView: some View {
    Map(position: .constant(.region(mapRegion))) {
      ForEach(viewModel.posts) { post in
        Marker(
          post.businessName,
          coordinate: post.businessLocationCoordinate
        )
        .tint(Constants.mapMarkerColor)
      }
    }
  }

  var contentView: some View {
    VStack {
      searchBar
      Spacer()
    }
    .bottomSheet(
      bottomSheetPosition: $bottomSheetPosition,
      switchablePositions: bottomSheetPositions
    ) { bottomSheetContent }
    .customBackground { postListBackground }
    .enableAppleScrollBehavior()
  }

  var searchBar: some View {
    NavigationLink {
      SearchPage()
    } label: {
      SearchBarView(
        title: "Explore",
        isDisabled: true
      )
    }
    .buttonStyle(PlainButtonStyle())
  }

  var bottomSheetContent: some View {
    VStack {
      postTags
      postList
    }
  }

  var postList: some View {
    VStack {
      ForEach(viewModel.posts) { post in
        PostCardView(
          post: post,
          coverWidth: screenSize.width * Constants.postCoverWidthProportion
        )
      }
      ForEach(viewModel.posts) { post in
        PostCardView(
          post: post,
          coverWidth: screenSize.width * Constants.postCoverWidthProportion
        )
      }
    }
  }

  var postTags: some View {
    ScrollView(.horizontal) {
      HStack {
        Spacer()
        ForEach(BusinessCategory.allCases, id: \.self) { category in
          let isSelected = category.rawValue == selectedTag
          TagView(tag: category.rawValue, isSelected: isSelected)
            .onTapGesture {
              if selectedTag != category.rawValue {
                selectedTag = category.rawValue
              } else {
                selectedTag = ""
              }
            }
        }
        Spacer()
      }
      .padding(.horizontal)
    }
  }

  var postListBackground: some View {
    UnevenRoundedRectangle(
      topLeadingRadius: Constants.bottomSheetCornerRadius,
      topTrailingRadius: Constants.bottomSheetCornerRadius
    )
    .fill(.background)
  }

  var bottomSheetPositions: [BottomSheetPosition] {
    [.dynamicBottom, .absoluteTop(300), .absoluteTop(bottomSheetTopPosition)]
  }

  var bottomSheetTopPosition: CGFloat {
    screenSize.height - topSafeAreaHeight - SearchBarView.Constants.height - 20
  }
}

private extension HomePage {
  func getNearbyPosts(withLocation location: CLLocation?) {
    guard let location else {
      return
    }
    Task {
      await viewModel.getNearbyPosts(
        withLocation: location,
        onError: handleListError
      )
    }
  }

  func handleListError(_ error: Error) {
    print(error)
  }
}

private enum Constants {
  static let mapMarkerColor = Color.locariePrimary
  static let postCoverWidthProportion = 0.8
  static let bottomSheetCornerRadius = 10.0
}

#Preview {
  HomePage(screenSize: CGSize(width: 393, height: 759))
}
