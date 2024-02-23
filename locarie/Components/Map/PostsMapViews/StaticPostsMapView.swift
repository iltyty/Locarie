//
//  StaticPostsMapView.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

@_spi(Experimental) import MapboxMaps
import SwiftUI

struct StaticPostsMapView: View {
  let posts: [PostDto]

  @Binding var selectedPost: PostDto

  @State var viewport: Viewport = .camera(
    center: .london,
    zoom: 12
  )

  var body: some View {
    Map(viewport: $viewport) {
      Puck2D()

      ForEvery(posts) { post in
        MapViewAnnotation(coordinate: post.businessLocationCoordinate) {
          BusinessMapAvatar(
            url: post.user.avatarUrl,
            amplified: post.id == selectedPost.id
          )
          .onTapGesture {
            selectedPost = post
          }
        }
      }
    }
    .ignoresSafeArea()
  }
}
