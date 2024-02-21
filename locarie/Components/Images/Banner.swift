//
//  Banner.swift
//  locarie
//
//  Created by qiuty on 14/01/2024.
//

import SwiftUI

struct Banner: View {
  let urls: [String]
  var indicator = true
  var rounded = true
  var isPortrait = true

  @State var height: CGFloat = 0

  var body: some View {
    GeometryReader { proxy in
      TabView {
        ForEach(urls.indices, id: \.self) { i in
          AsyncImageView(url: urls[i]) { image in
            image
              .resizable()
              .aspectRatio(aspectRatio, contentMode: .fill)
              .clipped()
          }
          .tag(i)
        }
      }
      .onAppear {
        height = proxy.size.width / aspectRatio
      }
      .clipShape(
        RoundedRectangle(cornerRadius: rounded ? Constants.cornerRadius : 0)
      )
      .tabViewStyle(.page(indexDisplayMode: indicator ? .always : .never))
      .frame(width: proxy.size.width, height: proxy.size.width / aspectRatio)
    }
    .frame(height: height)
  }

  private var aspectRatio: CGFloat {
    isPortrait ? Constants.portraitAspectRatio : Constants.landscapeAspectRatio
  }
}

struct BannerTestView: View {
  var body: some View {
    Banner(urls: [
      "http://localhost:8080/user_1/posts/post_4/1.jpg",
      "http://localhost:8080/user_1/posts/post_4/1.jpg",
    ])
    .padding(.horizontal)
  }
}

private enum Constants {
  static let cornerRadius: CGFloat = 20
  static let portraitAspectRatio: CGFloat = 3 / 4
  static let landscapeAspectRatio: CGFloat = 4 / 3
}

#Preview {
  BannerTestView()
}
