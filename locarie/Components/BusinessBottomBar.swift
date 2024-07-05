//
//  BusinessBottomBar.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct BusinessBottomBar: View {
  @Binding var business: UserDto
  let location: BusinessLocation?
  @ObservedObject var favoriteBusinessVM: FavoriteBusinessViewModel

  @State private var alreadyFollowed = false

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

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
      .padding(.top, BusinessBottomBarConstants.topPadding)
      .padding(.horizontal, BusinessBottomBarConstants.hPadding)
    }
    .onChange(of: business) { newBusiness in
      favoriteBusinessVM.checkFavoredBy(
        userId: cacheVM.getUserId(),
        businessId: newBusiness.id
      )
    }
    .onReceive(favoriteBusinessVM.$alreadyFollowed) { followed in
      alreadyFollowed = followed
    }
    .onReceive(favoriteBusinessVM.$state) { state in
      switch state {
      case .favoriteFinished:
        alreadyFollowed = true
      case .unfavoriteFinished:
        alreadyFollowed = false
      default: break
      }
    }
    .frame(height: BusinessBottomBarConstants.height)
    .ignoresSafeArea(edges: .bottom)
  }
}

private extension BusinessBottomBar {
  var favoriteButton: some View {
    Image(favoriteButtonName)
      .resizable()
      .scaledToFit()
      .frame(height: BusinessBottomBarConstants.iconSize)
      .foregroundStyle(
        alreadyFollowed ? Color.locariePrimary : .primary
      )
      .onTapGesture { favoriteButtonTapped() }
  }

  var favoriteButtonName: String { alreadyFollowed ? "Bookmark.Fill" : "Bookmark" }

  var directionButton: some View {
    Link(destination: navigationUrl) {
      Text("Direction")
    }
    .fontWeight(.bold)
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
      .fill(.white)
      .shadow(radius: BusinessBottomBarConstants.shadowRadius)
  }

  func favoriteButtonTapped() {
    if alreadyFollowed {
      favoriteBusinessVM.unfavorite(
        userId: cacheVM.getUserId(), businessId: business.id
      )
    } else {
      favoriteBusinessVM.favorite(
        userId: cacheVM.getUserId(), businessId: business.id
      )
    }
  }
}

enum BusinessBottomBarConstants {
  static let height: CGFloat = 85
  static let topPadding: CGFloat = 15
  static let hPadding: CGFloat = 40
  static let iconSize: CGFloat = 28
  static let shadowRadius: CGFloat = 1
}
