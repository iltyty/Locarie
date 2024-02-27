//
//  BusinessSearchView.swift
//  locarie
//
//  Created by qiuty on 25/02/2024.
//

import SwiftUI

struct BusinessSearchView: View {
  @Binding var searching: Bool
  var namespace: Namespace.ID = Namespace().wrappedValue

  @State var businessName = ""

  @StateObject var userListVM = UserListViewModel()

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
            Label(area.rawValue, image: "BlueMapIcon")
          }
        }
      }
    }
    .scrollIndicators(.hidden)
  }

  var businesses: [BusinessNameAvatarUrlDto] {
    userListVM.businesses.filter {
      businessName.isEmpty || $0.businessName.range(
        of: businessName,
        options: .caseInsensitive
      ) != nil
    }
  }

  var businessesView: some View {
    VStack(alignment: .leading, spacing: Constants.vSpacing) {
      Text("Businesses").foregroundStyle(Constants.businessesTitleColor)
      ForEach(businesses) { user in
        BusinessRowItem(user)
      }
    }
  }
}

private struct BusinessRowItem: View {
  let user: BusinessNameAvatarUrlDto

  init(_ user: BusinessNameAvatarUrlDto) {
    self.user = user
  }

  var body: some View {
    NavigationLink(destination: BusinessHomePage(uid: user.id)) {
      HStack {
        AvatarView(imageUrl: user.avatarUrl, size: Constants.avatarSize)
        Text(user.businessName).fontWeight(.semibold)
      }
    }
    .tint(.primary)
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
