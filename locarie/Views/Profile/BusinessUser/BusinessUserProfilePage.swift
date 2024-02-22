//
//  BusinessUserProfilePage.swift
//  locarie
//
//  Created by qiuty on 07/01/2024.
//

@_spi(Experimental) import MapboxMaps
import SwiftUI

struct BusinessUserProfilePage: View {
  @State private var screenSize: CGSize = .zero
  @State private var viewport: Viewport = .camera(
    center: .london, zoom: Constants.mapZoom
  )
  @State private var showingProfileCover = false

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared
  @StateObject private var profileVM = ProfileGetViewModel()

  var body: some View {
    GeometryReader { proxy in
      ZStack {
        VStack {
          content
          BottomTabView()
        }
        if showingProfileCover {
          profileCover
        }
      }
      .onAppear {
        screenSize = proxy.size
        profileVM.getProfile(userId: cacheVM.getUserId())
      }
      .onReceive(profileVM.$dto) { dto in
        viewport = .camera(
          center: dto.coordinate,
          zoom: Constants.mapZoom
        )
      }
    }
    .ignoresSafeArea(edges: .bottom)
  }

  private var content: some View {
    ZStack {
      mapView
      contentView
    }
  }
}

private extension BusinessUserProfilePage {
  var mapView: some View {
    Map(viewport: $viewport) {
      MapViewAnnotation(coordinate: profileVM.dto.coordinate) {
        Image("map")
          .onTapGesture {
            viewport = .camera(
              center: profileVM.dto.coordinate,
              zoom: Constants.mapZoom
            )
          }
      }
    }
    .ignoresSafeArea(edges: .all)
  }
}

private extension BusinessUserProfilePage {
  var contentView: some View {
    VStack {
      buttons
      Spacer()
      BottomSheet(detents: [.medium, .fraction(0.67)]) {
        ProfileView(
          id: cacheVM.getUserId(),
          user: profileVM.dto,
          isPresentingCover: $showingProfileCover
        )
      }
    }
  }

  var buttons: some View {
    ZStack {
      HStack {
        Spacer()
        profileEditButton
        Spacer()
      }
      settingsButton
    }
  }

  var profileEditButton: some View {
    NavigationLink(value: Router.Destination.userProfileEdit) {
      HStack {
        Image("EditIcon")
          .resizable()
          .scaledToFit()
          .frame(
            width: Constants.profileEditButtonIconSize,
            height: Constants.profileEditButtonIconSize
          )
        Text("Edit profile")
      }
      .padding(Constants.settingsButtonTextPadding)
      .background(profileEditButtonBackground)
    }
    .buttonStyle(.plain)
  }

  var profileEditButtonBackground: some View {
    Capsule()
      .fill(.background)
      .shadow(radius: Constants.buttonShadowRadius)
  }

  var settingsButton: some View {
    HStack {
      Spacer()
      NavigationLink(value: Router.Destination.settings) {
        Image(systemName: "gearshape")
          .font(.system(size: Constants.settingsButtonIconSize))
          .padding(Constants.settingsButtonIconPadding)
          .background(Circle().fill(.white))
          .padding(.trailing)
      }
      .buttonStyle(.plain)
    }
  }
}

private extension BusinessUserProfilePage {
  var profileCover: some View {
    BusinessProfileCover(
      user: profileVM.dto,
      isPresenting: $showingProfileCover
    )
  }
}

private enum Constants {
  static let vSpacing: CGFloat = 16

  static let mapZoom: CGFloat = 12
  static let buttonShadowRadius: CGFloat = 2.0

  static let profileEditButtonBorderColor: Color = .init(hex: 0xD9D9D9)
  static let profileEditButtonIconSize: CGFloat = 16

  static let settingsButtonIconPadding: CGFloat = 10
  static let settingsButtonIconSize: CGFloat = 24
  static let settingsButtonTextPadding: CGFloat = 10
}

#Preview {
  BusinessUserProfilePage()
}
