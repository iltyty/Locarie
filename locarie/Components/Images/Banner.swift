//
//  Banner.swift
//  locarie
//
//  Created by qiuty on 14/01/2024.
//

import SwiftUI

struct Banner: View {
  let urls: [String]
  let width: CGFloat
  let height: CGFloat
  var indicator = true
  var rounded = false

  var body: some View {
    TabView {
      ForEach(urls.indices, id: \.self) { i in
        AsyncImageView(url: urls[i]) { image in
          image
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height, alignment: .center)
            .clipped()
        }
        .tag(i)
      }
    }
    .frame(width: width, height: height)
    .clipShape(
      RoundedRectangle(cornerRadius: rounded ? Constants.cornerRadius : 0)
    )
    .tabViewStyle(.page(indexDisplayMode: indicator ? .always : .never))
  }
}

struct BannerTestView: View {
  var body: some View {
    GeometryReader { proxy in
      Banner(
        urls: [
          "https://picsum.photos/300/600",
          "https://picsum.photos/300/600",
          "https://picsum.photos/300/600",
          "https://picsum.photos/300/600",
          "https://picsum.photos/300/600",
        ],
        width: proxy.size.width,
        height: proxy.size.height / 2,
        rounded: true
      )
    }
  }
}

private enum Constants {
  static let cornerRadius = 20.0
}

#Preview {
  BannerTestView()
}
