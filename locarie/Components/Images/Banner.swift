//
//  Banner.swift
//  locarie
//
//  Created by qiuty on 14/01/2024.
//

import SwiftUI

struct Banner: View {
  let urls: [String]
  let height: CGFloat
  var indicator = true

  var body: some View {
    GeometryReader { proxy in
      ScrollView {
        VStack {
          TabView {
            ForEach(urls.indices, id: \.self) { i in
              AsyncImageView(url: urls[i]) { image in
                image.resizable()
                  .scaledToFill()
                  .frame(height: height, alignment: .center)
                  .clipped()
              }
              .tag(i)
            }
          }
          .frame(width: proxy.size.width, height: height)
          .tabViewStyle(.page(indexDisplayMode: indicator ? .always : .never))
        }
      }
      .ignoresSafeArea()
    }
  }
}

struct BannerTestView: View {
  var body: some View {
    GeometryReader { proxy in
      Banner(urls: [
        "https://picsum.photos/300/600",
        "https://picsum.photos/300/600",
        "https://picsum.photos/300/600",
        "https://picsum.photos/300/600",
        "https://picsum.photos/300/600",
      ], height: proxy.size.height)
    }
  }
}

#Preview {
  BannerTestView()
}
