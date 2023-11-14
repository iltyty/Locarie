//
//  FavoritePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import MapKit
import SwiftUI

struct FavoritePage: View {
    @EnvironmentObject var postViewModel: PostViewModel
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D.CP,
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
                            ForEach(postViewModel.favoritePosts) { post in
                                Marker(post.businessName, coordinate: post.businessLocationCoordinate)
                                    .tint(Constants.mapMarkerColor)
                            }
                        }
                        
                        ScrollView {
                            Group {
                                Spacer()
                                Capsule(style: .circular)
                                    .fill(.secondary)
                                    .frame(width: Constants.handlerWidth, height: Constants.handlerHeight)
                                    .padding(.top, 10)
                                
                                ForEach(postViewModel.favoritePosts) { post in
                                    PostCardView(post: post, coverWidth: proxy.size.width * Constants.postCoverWidthProportion)
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
    static let mapMarkerColor: Color = .mapMarkerOrange
    static let handlerWidth: CGFloat = 80
    static let handlerHeight: CGFloat = 5
    static let postCoverWidthProportion = 0.8
}
#Preview {
    FavoritePage()
        .environmentObject(BottomTabViewRouter())
        .environmentObject(PostViewModel())
}
