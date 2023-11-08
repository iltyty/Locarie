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
        center: CLLocationCoordinate2D.LSE,
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var atTheTop = false
    @State private var initOffset: CGFloat = 0
    @State private var endOffset: CGFloat = 0
    @State private var currentOffset: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    ZStack(alignment: .bottom) {
                        Map(position: .constant(.region(mapRegion))) {
                            Marker("LSE", coordinate: CLLocationCoordinate2D.LSE)
                                .tint(Color.mapMarkerOrange)
                            Marker("Marker1", coordinate: CLLocationCoordinate2D(latitude: 51.5346, longitude: -0.12641))
                                .tint(Color.mapMarkerOrange)
                            Marker("Marker2", coordinate: CLLocationCoordinate2D(latitude: 51.5246, longitude: -0.09841))
                                .tint(Color.mapMarkerOrange)
                            Marker("Marker3", coordinate: CLLocationCoordinate2D(latitude: 51.5196, longitude: -0.096641))
                                .tint(Color.mapMarkerOrange)
                            Marker("Marker4", coordinate: CLLocationCoordinate2D(latitude: 51.5206, longitude: -0.12641))
                                .tint(Color.mapMarkerOrange)
                        }
                        
                        ScrollView {
                            Group {
                                Spacer()
                                Capsule(style: .circular)
                                    .fill(.secondary)
                                    .frame(width: Constants.handlerWidth, height: Constants.handlerHeight)
                                    .padding(.top, 10)
                                
                                ForEach(0..<10) { _ in
                                    PostCardView(coverWidth: proxy.size.width * Constants.postCoverWidthProportion)
                                }
                            }
                            .background(
                                UnevenRoundedRectangle(topLeadingRadius: 10, topTrailingRadius: 10).fill(.white)
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
    
}

fileprivate struct Constants {
    static let navigationTitle = "Followed"
    static let handlerWidth: CGFloat = 80
    static let handlerHeight: CGFloat = 5
    static let postCoverWidthProportion = 0.8
}
#Preview {
    FavoritePage()
        .environmentObject(BottomTabViewRouter())
}
