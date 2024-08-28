//
//  BusinessSearchView.swift
//  locarie
//
//  Created by qiuty on 25/02/2024.
//

import SwiftUI

struct BusinessSearchView: View {
  @Binding var searching: Bool

  @State var businessName = ""
  @State private var loading = false

  @StateObject private var userListVM = UserListViewModel()
  @StateObject private var favoriteVM = FavoriteBusinessViewModel()
  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      searchBar
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
      businessesView
      Spacer()
    }
    .background(.white)
    .loadingIndicator(loading: $loading)
    .onReceive(userListVM.$state) { state in
      switch state {
      case .loading: loading = true
      default: loading = false
      }
    }
    .onAppear {
      favoriteVM.list(userId: cacheVM.getUserId())
      userListVM.listBusinesses()
    }
  }
}

private extension BusinessSearchView {
  var searchBar: some View {
    HStack {
      Image("Chevron.Left")
        .resizable()
        .scaledToFit()
        .frame(size: 18)
        .contentShape(Rectangle())
        .onTapGesture {
          searching = false
        }
      TextField("Search businesses", text: $businessName)
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
      if !businessName.isEmpty {
        Image("Xmark.Grey")
          .resizable()
          .scaledToFit()
          .frame(size: 18)
          .foregroundStyle(LocarieColor.greyDark)
          .onTapGesture {
            businessName = ""
          }
      }
    }
    .padding(.horizontal, 16)
    .frame(height: 48)
    .background {
      RoundedRectangle(cornerRadius: 25)
        .strokeBorder(LocarieColor.greyMedium, style: .init(lineWidth: 1.5))
    }
  }

  var businesses: [UserDto] {
    userListVM.businesses
      .filter {
        businessName.isEmpty || $0.businessName.range(
          of: businessName,
          options: .caseInsensitive
        ) != nil
      }
      .filter(\.isProfileComplete)
  }

  var businessesView: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: Constants.vSpacing) {
        areas.padding(.top, 16).padding(.horizontal, 16)
        Text("Businesses")
          .fontWeight(.bold)
          .foregroundStyle(LocarieColor.greyDark)
          .padding(.horizontal, 16)
        ForEach(businesses.indices, id: \.self) { i in
          VStack(alignment: .leading, spacing: 16) {
            let user = businesses[i]
            NavigationLink(value: Router.Int64Destination.businessHome(user.id, true)) {
              BusinessFollowedAvatarRow(user: user, isPresentingCover: .constant(false))
            }
            .buttonStyle(.plain)
            if i != businesses.count - 1 {
              LocarieDivider().padding(.horizontal, 16)
            }
          }
        }
      }
      .padding(.bottom, 48)
    }
    .scrollIndicators(.hidden)
  }

  var areas: some View {
    HStack {
      ForEach(LondonAreas.allCases, id: \.self) { area in
        HStack(spacing: 10) {
          Image("Map")
            .resizable()
            .scaledToFill()
            .frame(size: 18)
          Text(area.rawValue)
        }
        .padding(.horizontal, 12)
        .frame(height: 40)
        .background {
          RoundedRectangle(cornerRadius: 30)
            .strokeBorder(LocarieColor.greyMedium, style: .init(lineWidth: 1.5))
        }
      }
      Spacer()
    }
  }

  func isFollowed(_ id: Int64) -> Bool {
    favoriteVM.users.contains { $0.id == id }
  }
}

private enum Constants {
  static let vSpacing: CGFloat = 24
  static let searchBarHeight: CGFloat = 40
  static let searchBarCornerRadius: CGFloat = 25
  static let avatarSize: CGFloat = 40
}

#Preview {
  BusinessSearchView(searching: .constant(true))
}
