//
//  Banner.swift
//  locarie
//
//  Created by qiuty on 14/01/2024.
//

import SwiftUI

struct Banner: View {
  let urls: [String]
  var fullToggle = false
  var indicator: IndicatorPosition = .inner
  var rounded = true
  var isPortrait = true

  @State private var index = 0
  @State private var presentingFullScreen = false
  @State private var screenSize: CGSize = .zero

  var body: some View {
    GeometryReader { proxy in
      VStack(spacing: 10) {
        ZStack(alignment: .bottom) {
          imageView
            .frame(width: proxy.size.width, height: proxy.size.width / aspectRatio)
            .onAppear {
              screenSize = proxy.size
            }
          if indicator == .inner {
            indicators.padding(.bottom, 5)
          }
        }
        if indicator == .bottom {
          indicators
        }
      }
    }
    .frame(height: height + (indicator == .bottom ? 16 : 0))
    .fullScreenCover(isPresented: $presentingFullScreen) {
      ImageFullScreenView(urls[index])
    }
  }

  private var imageView: some View {
    ZStack(alignment: .topTrailing) {
      TabView(selection: $index) {
        if urls.isEmpty {
          defaultImage
        } else {
          images
        }
      }
      if fullToggle {
        Image(systemName: "arrow.down.left.and.arrow.up.right")
          .resizable()
          .scaledToFit()
          .foregroundStyle(.white)
          .frame(width: Constants.fullIconSize, height: Constants.fullIconSize)
          .padding()
          .overlay {
            Color.clear
              .contentShape(Rectangle())
              .simultaneousGesture(TapGesture().onEnded { _ in
                presentingFullScreen = true
              })
          }
      }
    }
    .clipShape(RoundedRectangle(cornerRadius: rounded ? Constants.cornerRadius : 0))
    .tabViewStyle(.page(indexDisplayMode: .never))
  }

  private var indicators: some View {
    HStack(spacing: 5) {
      ForEach(urls.indices, id: \.self) { i in
        Image(systemName: "circle.fill")
          .resizable()
          .scaledToFit()
          .frame(width: 6, height: 6)
          .foregroundStyle(index == i ? LocarieColor.primary : LocarieColor.greyMedium)
      }
    }
  }

  private var height: CGFloat {
    screenSize.width / aspectRatio
  }

  private var aspectRatio: CGFloat {
    isPortrait ? Constants.portraitAspectRatio : Constants.landscapeAspectRatio
  }

  private var defaultImage: some View {
    ZStack {
      LocarieColor.greyMedium

      Image("DefaultImage")
        .resizable()
        .scaledToFit()
        .frame(width: Constants.defaultImageSize, height: Constants.defaultImageSize)
    }
  }

  private var images: some View {
    ForEach(urls.indices, id: \.self) { i in
      AsyncImage(url: URL(string: urls[i])) { image in
        image
          .resizable()
          .scaledToFill()
          .aspectRatio(aspectRatio, contentMode: .fill)
          .clipped()
          .frame(alignment: .center)
      } placeholder: {
        defaultImage
      }
      .tag(i)
    }
  }
}

extension Banner {
  enum IndicatorPosition: Equatable {
    case none, inner, bottom
  }
}

private enum Constants {
  static let fullIconSize: CGFloat = 16
  static let cornerRadius: CGFloat = 18
  static let portraitAspectRatio: CGFloat = 3 / 4
  static let landscapeAspectRatio: CGFloat = 4 / 3
  static let defaultImageSize: CGFloat = 28
}

#Preview {
  Banner(
    urls: [
      "https://picsum.photos/300/200",
      "https://picsum.photos/300/200",
    ],
    isPortrait: false
  )
  .padding(.horizontal)
}
