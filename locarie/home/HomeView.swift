//
//  HomeView.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @State var hello = "Explore"
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D.LSE,
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        ZStack(alignment: .top) {
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
            
            VStack {
                SearchBar(text: hello)
                
                Spacer()
                
                PostCard()
            }
        }
    }
}

extension Color {
    static let mapMarkerOrange = Color(hex: 0xff571b)

    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

extension CLLocationCoordinate2D {
    static let LSE = CLLocationCoordinate2D(
        latitude: 51.51463, longitude: -0.11641
    )
}

#Preview {
    HomeView()
}
