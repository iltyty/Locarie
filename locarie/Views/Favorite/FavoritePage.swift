//
//  FavoritePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import MapKit
import SwiftUI

struct FavoritePage: View {
  @State private var mapRegion = MKCoordinateRegion(
    center: CLLocationCoordinate2D.CP,
    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
  )
  @State private var atTheTop = false
  @State private var initOffset: CGFloat = 0
  @State private var endOffset: CGFloat = 0
  @State private var currentOffset: CGFloat = 0

  var body: some View {
    GeometryReader { proxy in
      VStack(spacing: 0) {
        ZStack(alignment: .bottom) {
          Map(position: .constant(.region(mapRegion))) {}

          ScrollView {
            Group {
              Spacer()
              Capsule(style: .circular)
                .fill(.secondary)
                .frame(
                  width: Constants.handlerWidth,
                  height: Constants.handlerHeight
                )
                .padding(.top, 10)
            }
            .background(
              UnevenRoundedRectangle(
                topLeadingRadius: 10,
                topTrailingRadius: 10
              ).fill(.background)
            )
            .padding(.top, proxy.size.height * 4 / 5)
          }
          .scrollIndicators(.hidden)
        }

        BottomTabView()
      }
      .navigationTitle(Constants.navigationTitle)
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

private enum Constants {
  static let navigationTitle = "Followed"
  static let mapMarkerColor: Color = .locariePrimary
  static let handlerWidth: CGFloat = 80
  static let handlerHeight: CGFloat = 5
  static let postCoverWidthProportion = 0.8
}

#Preview {
  FavoritePage()
}
