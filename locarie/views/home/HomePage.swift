//
//  HomePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import SwiftUI
import MapKit

struct HomePage: View {
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
                                Marker(post.businessName, coordinate: post.businessLocationCoordinate)
                                    .tint(Constants.mapMarkerColor)
                            }
                        }
                        
                        VStack {
                            NavigationLink {
                                SearchPage()
                            } label: {
                                SearchBarView(title: "Explore", isDisabled: true)
                            }
                            .buttonStyle(PlainButtonStyle())
                            Spacer()
                            PostCardView(post: postViewModel.posts[0], coverWidth: proxy.size.width * Constants.postCoverWidthProportion)
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
    static let CP = CLLocationCoordinate2D(
        latitude: 51.546781359379445, longitude: -0.12298996843934423
    )
}

fileprivate struct Constants {
    static let postCoverWidthProportion = 0.8
    static let mapMarkerColor = Color.mapMarkerOrange
}

#Preview {
    return HomePage()
        .environmentObject(BottomTabViewRouter())
        .environmentObject(PostViewModel())
}
