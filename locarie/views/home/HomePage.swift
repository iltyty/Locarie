//
//  HomePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import SwiftUI
import MapKit

struct HomePage: View {
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D.LSE,
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                VStack(spacing: 0) {
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
                            NavigationLink {
                                SearchPage()
                            } label: {
                                SearchBarView(title: "Explore", isDisabled: true)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                            
                            PostCardView(coverWidth: proxy.size.width * Constants.postCoverWidthProportion)
                        }
                    }
                    
                    BottomTabView()
                }
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

fileprivate struct Constants {
    static let postCoverWidthProportion = 0.8
}

#Preview {
    let viewRouter = BottomTabViewRouter()
    return HomePage()
        .environmentObject(viewRouter)
}
