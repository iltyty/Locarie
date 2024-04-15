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

  @State var screenSize: CGSize = .zero

  var body: some View {
    GeometryReader { proxy in
      TabView {
        if urls.isEmpty {
          defaultImage
        } else {
          images
        }
      }
      .onAppear {
        screenSize = proxy.size
      }
      .clipShape(
        RoundedRectangle(cornerRadius: rounded ? Constants.cornerRadius : 0)
      )
      .tabViewStyle(.page(indexDisplayMode: indicator && !urls.isEmpty ? .always : .never))
      .frame(width: proxy.size.width, height: proxy.size.width / aspectRatio)
    }
    .frame(height: height)
  }

  private var height: CGFloat {
    screenSize.width / aspectRatio
  }

  private var aspectRatio: CGFloat {
    isPortrait ? Constants.portraitAspectRatio : Constants.landscapeAspectRatio
  }

  private var defaultImage: some View {
    ZStack {
      LocarieColor.greyMedium.shadow(radius: Constants.defaultImageShadowRadius)

      Image("DefaultImage")
        .resizable()
        .scaledToFit()
        .frame(width: Constants.defaultImageSize, height: Constants.defaultImageSize)
    }
  }

  private var images: some View {
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
}

struct BannerTestView: View {
  var body: some View {
    Banner(urls: [], isPortrait: false)
      .padding(.horizontal)
  }
}

private enum Constants {
  static let cornerRadius: CGFloat = 16
  static let portraitAspectRatio: CGFloat = 3 / 4
  static let landscapeAspectRatio: CGFloat = 4 / 3
  static let defaultImageSize: CGFloat = 28
  static let defaultImageShadowRadius: CGFloat = 2
}

#Preview {
  BannerTestView()
}
