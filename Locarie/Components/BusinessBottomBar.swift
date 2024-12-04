//
//  BusinessBottomBar.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct BusinessBottomBar: View {
  @Binding var business: UserDto
  @ObservedObject var favoriteBusinessVM: FavoriteBusinessViewModel

  @State private var alreadyFollowed = false
  @State private var presentingLoginSheet = false

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
    .frame(height: BusinessBottomBarConstants.height)
    .loginSheet(isPresented: $presentingLoginSheet)
    .ignoresSafeArea(edges: .bottom)
    .onAppear {
      favoriteBusinessVM.checkFavoredBy(
        userId: cacheVM.getUserId(),
        businessId: business.id
      )
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
    .disabled(business.address.isEmpty)
  }

  var navigationUrl: URL {
    let destination = business.address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    return URL(
      string: "https://www.google.com/maps/dir/?api=1&destination=\(destination)"
    )!
  }

  var background: some View {
    Rectangle()
      .fill(.white)
      .shadow(radius: BusinessBottomBarConstants.shadowRadius)
  }

  func favoriteButtonTapped() {
    if !cacheVM.isLoggedIn() {
      presentingLoginSheet = true
    } else if alreadyFollowed {
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
  static let height: CGFloat = 78
  static let topPadding: CGFloat = 15
  static let hPadding: CGFloat = 40
  static let iconSize: CGFloat = 28
  static let shadowRadius: CGFloat = 1
}
