//
//  HomePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import MapKit
import SwiftUI

struct HomePage: View {
  @AppStorage(GlobalConstants.userIdKey) var userId: Double = 0
  @EnvironmentObject var postViewModel: PostViewModel

  @State private var mapRegion = MKCoordinateRegion(
    center: CLLocationCoordinate2D.CP,
    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.1)
  )

  var body: some View {
    NavigationStack {
      GeometryReader { proxy in
        VStack(spacing: 0) {
          ZStack(alignment: .top) {
            Map(position: .constant(.region(mapRegion))) {
              ForEach(postViewModel.posts) { post in
                Marker(
                  post.businessName,
                  coordinate: post.businessLocationCoordinate
                )
                .tint(Constants.mapMarkerColor)
              }
            }

            VStack {
              NavigationLink {
//                                SearchPage()
                CustomBackSwipeView()
              } label: {
                SearchBarView(
                  title: "Explore",
                  isDisabled: true
                )
              }
              .buttonStyle(PlainButtonStyle())
              Spacer()
              PostCardView(
                post: postViewModel.posts[0],
                coverWidth: proxy.size.width * Constants
                  .postCoverWidthProportion
              )
            }
          }

          BottomTabView()
        }
      }
    }
  }
}

extension Color {
  static let mapMarkerOrange = Color(hex: 0xFF571B)

  init(hex: UInt, alpha: Double = 1) {
    self.init(
      .sRGB,
      red: Double((hex >> 16) & 0xFF) / 255,
      green: Double((hex >> 08) & 0xFF) / 255,
      blue: Double((hex >> 00) & 0xFF) / 255,
      opacity: alpha
    )
  }
}

extension CLLocationCoordinate2D {
  static let CP = CLLocationCoordinate2D(
    latitude: 51.546781359379445, longitude: -0.12298996843934423
  )
}

private enum Constants {
  static let postCoverWidthProportion = 0.8
  static let mapMarkerColor = Color.mapMarkerOrange
}

#Preview {
  HomePage()
    .environmentObject(BottomTabViewRouter())
    .environmentObject(PostViewModel())
}
