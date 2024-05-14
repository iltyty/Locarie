//
//  ImageFullScreenView.swift
//  locarie
//
//  Created by qiuty on 14/05/2024.
//

import SwiftUI

struct ImageFullScreenView: View {
  let url: String

  @Environment(\.dismiss) private var dismiss

  @State private var scale: CGFloat = 1
  @State private var lastScale: CGFloat = 0
  @State private var offset: CGSize = .zero
  @State private var lastOffset: CGSize = .zero
  @GestureState private var interacting = false

  init(_ url: String) {
    self.url = url
  }

  var body: some View {
    ZStack {
      Color.black.contentShape(Rectangle())
      imageView
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
    .onTapGesture {
      dismiss()
    }
    .ignoresSafeArea()
  }

  private var imageView: some View {
    AsyncImage(url: URL(string: url)) { image in
      image.resizable()
        .scaledToFit()
        .ignoresSafeArea()
    } placeholder: {
      LoadingIndicator()
    }
//    .scaleEffect(scale)
//    .offset(offset)
//    .gesture(dragGesture)
//    .gesture(magnifyGesture)
  }

  private var dragGesture: some Gesture {
    DragGesture()
      .updating($interacting) { _, out, _ in
        out = true
      }
      .onChanged { value in
        let translation = value.translation
        offset = CGSize(
          width: translation.width + lastOffset.width,
          height: translation.height + lastOffset.height
        )
      }
      .onEnded { _ in
        lastOffset = offset
      }
  }

  private var magnifyGesture: some Gesture {
    MagnificationGesture()
      .updating($interacting) { _, out, _ in
        out = true
      }
      .onChanged { value in
        scale = value + lastScale
        if scale < 1 {
          scale = 1
        } else if scale > Constants.maxScale {
          scale = Constants.maxScale
        }
      }
      .onEnded { _ in
        withAnimation(.spring) {
          if scale < 1 {
            scale = 1
            lastScale = 0
          } else if scale > Constants.maxScale {
            scale = Constants.maxScale
            lastScale = scale - 1
          } else {
            lastScale = scale - 1
          }
        }
      }
  }
}

private enum Constants {
  static let maxScale: CGFloat = 5
}

#Preview {
  ImageFullScreenView("https://picsum.photos/600/400")
}
