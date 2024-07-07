//
//  ImageCropView.swift
//  locarie
//
//  Created by qiuty on 07/05/2024.
//

import SwiftUI

struct ImageCropView: View {
  var crop: ImageCrop
  var image: Binding<UIImage?>
  var onCrop: (UIImage?, Bool) -> Void

  @Environment(\.dismiss) var dismiss

  @State private var scale: CGFloat = 1
  @State private var lastScale: CGFloat = 0
  @State private var offset: CGSize = .zero
  @State private var lastOffset: CGSize = .zero
  @GestureState private var interacting: Bool = false

  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()
      VStack {
        navigationBar.foregroundStyle(.white)
        imageView()
          .background(Color.white.clipShape(clipShape()))
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .contentShape(Rectangle())
      }
    }
  }

  private var navigationBar: some View {
    NavigationBar("Crop image", left: dismissButton, right: confirmButton)
  }

  private var dismissButton: some View {
    Image(systemName: "xmark")
      .font(.callout)
      .fontWeight(.semibold)
      .onTapGesture {
        dismiss()
      }
  }

  private var confirmButton: some View {
    Image(systemName: "checkmark")
      .font(.callout)
      .fontWeight(.semibold)
      .onTapGesture {
        DispatchQueue.main.async {
          let renderer = ImageRenderer(content: imageView())
          renderer.proposedSize = .init(crop.size())
          if let image = renderer.uiImage {
            onCrop(image, true)
          } else {
            onCrop(nil, false)
          }
          dismiss()
        }
      }
  }

  @ViewBuilder
  private func imageView() -> some View {
    let cropSize = crop.size()
    GeometryReader {
      let size = $0.size
      if let image = image.wrappedValue {
        Image(uiImage: image)
          .resizable()
          .scaledToFill()
          .frame(width: cropSize.width, height: cropSize.height)
          .overlay {
            GeometryReader { proxy in
              let rect = proxy.frame(in: .named(Constants.coordinateSpaceName))
              Color.clear
                .onChange(of: interacting) { newValue in
                  withAnimation(.easeInOut(duration: 0.2)) {
                    if rect.minX > 0 {
                      offset.width -= rect.minX
                      haptic(.medium)
                    }
                    if rect.minY > 0 {
                      offset.height -= rect.minY
                      haptic(.medium)
                    }
                    if rect.maxX < size.width {
                      offset.width = rect.minX - offset.width
                      haptic(.medium)
                    }
                    if rect.maxY < size.height {
                      offset.height = rect.minY - offset.height
                      haptic(.medium)
                    }
                  }
                  if !newValue {
                    lastOffset = offset
                  }
                }
            }
          }
      }
    }
    .scaleEffect(scale)
    .offset(offset)
    .gesture(dragGesture)
    .gesture(magnifyGesture)
    .coordinateSpace(name: Constants.coordinateSpaceName)
    .frame(width: cropSize.width, height: cropSize.height)
    .clipShape(clipShape())
    .clipped()
  }

  private func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
  }

  private func clipShape() -> AnyShape {
    if case .circle = crop {
      AnyShape(Circle())
    } else {
      AnyShape(Rectangle())
    }
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
  static let maxScale: CGFloat = 3
  static let coordinateSpaceName = "CropView"
}

private struct ImageCropTestView: View {
  @State private var image: UIImage?
  @State private var isCropping = false

  var body: some View {
    Group {
      if let image {
        Image(uiImage: image)
          .resizable()
          .scaledToFill()
          .frame(size: 250)
      } else {
        Text("No image selected, click to select")
          .onTapGesture {
            isCropping = true
          }
      }
    }
    .fullScreenCover(isPresented: $isCropping) {
      ImageCropView(crop: .circle(250), image: .constant(UIImage(named: "LocarieIcon"))) { image, status in
        if status {
          self.image = image
        }
      }
    }
  }
}

#Preview {
  ImageCropTestView()
}
