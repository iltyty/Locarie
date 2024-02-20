//
//  SwitchableBanner.swift
//  locarie
//
//  Created by qiuty on 04/02/2024.
//

import SwiftUI

struct SwitchableBanner: View {
  let width: CGFloat
  let height: CGFloat
  let mainImageUrls: [String]
  let secondaryImageUrl: String

  @State var switched = false

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      mainContent
      secondaryContent
    }
  }

  private var mainContent: some View {
    Group {
      if switched {
        secondaryImage
      } else {
        mainImages
      }
    }
    .frame(height: height)
  }

  private var secondaryContent: some View {
    Group {
      if switched {
        mainImages
      } else {
        secondaryImage
      }
    }
    .frame(
      width: Constants.secondaryImageSize,
      height: Constants.secondaryImageSize
    )
    .padding()
    .onTapGesture {
      withAnimation(.spring) {
        switched.toggle()
      }
    }
  }

  private var mainImages: some View {
    Banner(
      urls: mainImageUrls,
      width: bannerWidth,
      height: bannerHeight,
      rounded: true
    )
  }

  private var bannerWidth: CGFloat {
    switched ? Constants.secondaryImageSize : width
  }

  private var bannerHeight: CGFloat {
    switched ? Constants.secondaryImageSize : height
  }

  private var secondaryImage: some View {
    AsyncImageView(url: secondaryImageUrl) { image in
      image
        .resizable()
        .scaledToFill()
        .frame(
          width: imageWidth,
          height: imageHeight
        )
        .clipped()
        .clipShape(
          RoundedRectangle(
            cornerRadius: Constants.secondaryImageCornerRadius
          )
        )
    }
  }

  private var imageWidth: CGFloat {
    switched ? width : Constants.secondaryImageSize
  }

  private var imageHeight: CGFloat {
    switched ? height : Constants.secondaryImageSize
  }
}

private enum Constants {
  static let secondaryImageSize = 72.0
  static let secondaryImageCornerRadius = 20.0
}

#Preview {
  GeometryReader { proxy in
    SwitchableBanner(
      width: proxy.size.width,
      height: proxy.size.height / 2,
      mainImageUrls: [
        "https://images.unsplash.com/photo-1682685796766-0fddd3e480de?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHx8",
        "https://plus.unsplash.com/premium_photo-1706430116089-feb9c2725009?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyfHx8ZW58MHx8fHx8",
        "https://images.unsplash.com/photo-1682687220640-9d3b11ca30e5?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHw2fHx8ZW58MHx8fHx8",
      ],
      secondaryImageUrl: "https://plus.unsplash.com/premium_photo-1699596809632-22848594654c?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzMnx8fGVufDB8fHx8fA%3D%3D"
    )
    .padding()
  }
}
