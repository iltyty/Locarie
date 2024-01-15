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

  var body: some View {
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
      .frame(height: height)
      .tabViewStyle(.page(indexDisplayMode: .always))
    }
  }
}

#Preview {
  Banner(urls: [
    "https://picsum.photos/600",
    "https://picsum.photos/600",
    "https://picsum.photos/600",
    "https://picsum.photos/600",
  ], height: 200)
}
