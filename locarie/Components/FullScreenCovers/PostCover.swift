//
//  PostCover.swift
//  locarie
//
//  Created by qiuty on 21/02/2024.
//
import CoreLocation
import SwiftUI

struct PostCover: View {
  let post: PostDto
  @Binding var isPresenting: Bool
  let locationManager = LocationManager()

  var body: some View {
    VStack(alignment: .leading) {
      coverTop
      blank
      postImages
      postStatus
      blank
      favoriteButton
    }
    .padding(.horizontal)
    .background(.thickMaterial.opacity(CoverCommonConstants.backgroundOpacity))
    .contentShape(Rectangle())
  }
}

private extension PostCover {
  var coverTop: some View {
    CoverTopView(
      user: post.user,
      sharePreviewText: post.content,
      isPresenting: $isPresenting
    )
  }

  var blank: some View {
    Color
      .clear
      .contentShape(Rectangle())
      .onTapGesture {
        withAnimation(.spring) {
          isPresenting = false
        }
      }
  }

  var postImages: some View {
    Banner(urls: post.imageUrls).padding(.bottom)
  }

  var postStatus: some View {
    HStack {
      Text(getTimeDifferenceString(from: post.time)).foregroundStyle(.green)
      Text("·")
      Text(formatDistance(distance: distance)).foregroundStyle(.secondary)
    }
  }

  var distance: Double {
    guard let location = locationManager.location else { return 0 }
    return location.distance(
      from: CLLocation(
        latitude: post.user.location?.latitude ?? 0,
        longitude: post.user.location?.longitude ?? 0
      )
    )
  }

  var favoriteButton: some View {
    HStack {
      Spacer()
      Button {
        print("tapped")
      } label: {
        Image(systemName: "star")
          .resizable()
          .background(favoriteButtonBackground)
      }
    }
  }

  var favoriteButtonBackground: some View {
    Circle()
      .fill(.background)
      .shadow(radius: Constants.favoriteButtonShadowRadius)
  }
}

private enum Constants {
  static let favoriteButtonShadowRadius: CGFloat = 2
}
