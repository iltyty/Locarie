//
//  BusinessSearchView.swift
//  locarie
//
//  Created by qiuty on 25/02/2024.
//

import Combine
import CoreLocation
import SwiftUI

struct BusinessSearchView: View {
  @Binding var searching: Bool

  @StateObject private var vm = TextFieldObserver()

  //TODO: pagination not implemented yet
  @StateObject private var userListVM = UserListViewModel(size: 100)
  @ObservedObject private var cacheVM = LocalCacheViewModel.shared
  @StateObject private var locationManager = LocationManager()

  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      searchBar
      businessesView
      Spacer()
    }
    .padding(.top, 8)
    .padding(.horizontal, 16)
    .background(.white)
    .onReceive(vm.$debouncedName) { name in
      guard !name.isEmpty else { return }
      // clear UserListViewModel for the next query
      userListVM.clear()
      userListVM.listBusinesses(
        with: locationManager.location?.coordinate ?? .london,
        name: name
      )
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
      TextField("Search businesses", text: $vm.name)
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
      if !vm.name.isEmpty {
        Image("Xmark.Grey")
          .resizable()
          .scaledToFit()
          .frame(size: 18)
          .foregroundStyle(LocarieColor.greyDark)
          .onTapGesture {
            vm.name = ""
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

  var businessesView: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 0) {
        areas
        Text("Businesses")
          .fontWeight(.bold)
          .foregroundStyle(LocarieColor.greyDark)
          .padding(.vertical, 21)
        ForEach(userListVM.businesses) { user in
          NavigationLink(value: Router.BusinessHomeDestination.businessHome(
            user.id,
            user.location?.latitude ?? CLLocationCoordinate2D.london.latitude,
            user.location?.longitude ?? CLLocationCoordinate2D.london.longitude,
            true
          )) {
            BusinessSearchAvatarRow(user: user, isPresentingCover: .constant(false))
              .padding(.bottom, 16)
          }
          .buttonStyle(.plain)
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
}

private extension BusinessSearchView {
  class TextFieldObserver: ObservableObject {
    @Published var name = ""
    @Published var debouncedName = ""
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init() {
      $name.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
        .sink { [weak self] value in
          guard let self else { return }
          self.debouncedName = value
        }
        .store(in: &subscriptions)
    }
  }
}

private enum Constants {
  static let searchBarHeight: CGFloat = 40
  static let searchBarCornerRadius: CGFloat = 25
  static let avatarSize: CGFloat = 40
}

#Preview {
  BusinessSearchView(searching: .constant(true))
}
