//
//  BusinessBottomBar.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct BusinessBottomBar: View {
  let businessId: Int64
  let location: BusinessLocation?

  @State private var alreadyFollowed = false

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  @StateObject private var favoriteBusinessVM = FavoriteBusinessViewModel()

  var body: some View {
    ZStack(alignment: .top) {
      background
      HStack {
        Spacer()
        favoriteButton
        Spacer()
        Spacer()
        directionButton
        Spacer()
      }
      .padding(.top, Constants.topPadding)
      .padding(.horizontal, Constants.hPadding)
    }
    .onAppear {
      favoriteBusinessVM.checkFavoredBy(
        userId: cacheVM.getUserId(),
        businessId: businessId
      )
    }
    .onReceive(favoriteBusinessVM.$alreadyFollowed) { followed in
      alreadyFollowed = followed
    }
    .onReceive(favoriteBusinessVM.$state, perform: { state in
      switch state {
      case .favoriteFinished:
        alreadyFollowed = true
      case .unfavoriteFinished:
        alreadyFollowed = false
      default: break
      }
    })
    .fontWeight(.semibold)
    .frame(height: Constants.height)
    .ignoresSafeArea(edges: .bottom)
  }
}

private extension BusinessBottomBar {
  var favoriteButton: some View {
    Image(systemName: favoriteButtonSystemName)
      .resizable()
      .scaledToFit()
      .frame(height: Constants.iconSize)
      .foregroundStyle(
        alreadyFollowed ? Color.locariePrimary : .primary
      )
      .onTapGesture { favoriteButtonTapped() }
  }

  var favoriteButtonSystemName: String {
    if alreadyFollowed {
      "bookmark.fill"
    } else {
      "bookmark"
    }
  }

  var directionButton: some View {
    Link(destination: navigationUrl) {
      Text("Direction")
    }
    .tint(.primary)
    .buttonStyle(.plain)
    .disabled(location == nil)
  }

  var navigationUrl: URL {
    URL(
      string: "https://www.google.com/maps?saddr=&daddr=\(location?.latitude ?? 0)," +
        "\(location?.longitude ?? 0)&directionsmode=walking"
    )!
  }

  var background: some View {
    Rectangle()
      .fill(.background)
      .shadow(radius: Constants.shadowRadius)
  }

  func favoriteButtonTapped() {
    if alreadyFollowed {
      favoriteBusinessVM.unfavorite(
        userId: cacheVM.getUserId(), businessId: businessId
      )
    } else {
      favoriteBusinessVM.favorite(
        userId: cacheVM.getUserId(), businessId: businessId
      )
    }
  }
}

private enum Constants {
  static let height: CGFloat = 85
  static let topPadding: CGFloat = 15
  static let hPadding: CGFloat = 40
  static let iconSize: CGFloat = 28
  static let shadowRadius: CGFloat = 1
}
