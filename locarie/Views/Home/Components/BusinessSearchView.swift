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
    VStack(alignment: .leading, spacing: Constants.vSpacing) {
      searchBar
      areas
      businessesView
      Spacer()
    }
    .padding(.horizontal, 16)
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
      Image(systemName: "chevron.left")
        .resizable()
        .scaledToFit()
        .frame(width: 18, height: 18)
      TextField("Search businesses", text: $businessName)
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
      Image(systemName: "xmark")
        .frame(width: 18, height: 18)
        .onTapGesture {
          if !businessName.isEmpty {
            businessName = ""
          } else {
            withAnimation(.spring) {
              searching = false
            }
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

  var areas: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(LondonAreas.allCases, id: \.self) { area in
          HStack(spacing: 10) {
            Image("Map")
              .resizable()
              .scaledToFill()
              .frame(width: 18, height: 18)
            Text(area.rawValue)
          }
          .padding(.horizontal, 12)
          .frame(height: 40)
          .background {
            RoundedRectangle(cornerRadius: 30)
              .strokeBorder(LocarieColor.greyMedium, style: .init(lineWidth: 1.5))
          }
        }
      }
    }
    .scrollIndicators(.hidden)
  }

  var businesses: [UserDto] {
    userListVM.businesses.filter {
      businessName.isEmpty || $0.businessName.range(
        of: businessName,
        options: .caseInsensitive
      ) != nil
    }
  }

  var businessesView: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: Constants.vSpacing) {
        Text("Businesses").foregroundStyle(LocarieColor.greyDark)
        ForEach(businesses) { user in
          NavigationLink(value: Router.Int64Destination.businessHome(user.id)) {
            BusinessFollowedAvatarRow(user: user, followed: isFollowed(user.id), isPresentingCover: .constant(false))
          }
          .buttonStyle(.plain)
        }
      }
    }
    .scrollIndicators(.hidden)
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
