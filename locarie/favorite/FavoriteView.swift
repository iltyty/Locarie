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
                
                GeometryReader { proxy in
                    VStack {
                        Capsule()
                            .fill(.gray)
                            .frame(width: 50, height: 5)
                            .padding(.top)
                        PostCard()
                        PostCard()
                        PostCard()
                    }
                    .background(.white).clipShape(UnevenRoundedRectangle(
                        topLeadingRadius: 10, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 10
                    ))
                    .offset(y: proxy.size.height-100)
                    .offset(y: currentOffset)
                    .offset(y: endOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.spring()) {
                                    currentOffset = value.translation.height
                                }
                            }
                            .onEnded { value in
                                withAnimation(.spring()) {
                                    if currentOffset < -150{
                                        endOffset = -(proxy.size.height - 100)
                                        atTheTop = true
                                    } else if endOffset != 0 && currentOffset > 150 {
                                        endOffset = .zero
                                        atTheTop = false
                                    }
                                    currentOffset = 0
                                }
                            }
                    )
                }
            }
            .navigationTitle(Constants.navigationTitle).navigationBarTitleDisplayMode(.inline)
        }
    }
    
    struct Constants {
        static let navigationTitle = "Followed"
    }
}

#Preview {
    FavoriteView()
}
