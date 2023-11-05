//
//  FavoriteView.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import MapKit
import SwiftUI

struct FavoriteView: View {
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D.LSE,
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var atTheTop = false
    @State private var initOffset: CGFloat = 0
    @State private var endOffset: CGFloat = 0
    @State private var currentOffset: CGFloat = 0
    
    var body: some View {
        NavigationView {
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
                
                BottomDrawerView(offsetY: 400) {
                    ScrollView {
                        ForEach(0..<10) { _ in
                            PostCard()
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .navigationTitle(Constants.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    struct Constants {
        static let navigationTitle = "Followed"
    }
}

#Preview {
    FavoriteView()
}
