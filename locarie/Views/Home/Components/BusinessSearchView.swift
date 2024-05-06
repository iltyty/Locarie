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
    .padding(.horizontal)
    .background(.background)
    .onAppear {
      favoriteVM.list(userId: cacheVM.getUserId())
      userListVM.listBusinesses()
    }
  }
}

private extension BusinessSearchView {
  var searchBar: some View {
    searchBarBackground.overlay {
      HStack {
        Image(systemName: "magnifyingglass")
          .padding(.leading)
        TextField("Search businesses", text: $businessName)
          .autocorrectionDisabled()
          .textInputAutocapitalization(.never)
        Image(systemName: "xmark")
          .padding(.trailing)
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
    }
  }

  var searchBarBackground: some View {
    RoundedRectangle(cornerRadius: Constants.searchBarCornerRadius)
      .fill(.background)
      .frame(height: Constants.searchBarHeight)
      .shadow(color: .gray, radius: 2)
  }

  var areas: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(LondonAreas.allCases, id: \.self) { area in
          CapsuleButton {
            Label(area.rawValue, image: "Map")
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
        Text("Businesses").foregroundStyle(Constants.businessesTitleColor)
        ForEach(businesses) { user in
          BusinessFollowedAvatarRow(user: user, followed: isFollowed(user.id), isPresentingCover: .constant(false))
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
  static let businessesTitleColor: Color = .init(hex: 0x707579)
}

#Preview {
  BusinessSearchView(searching: .constant(true))
}
