//
//  BottomSheet.swift
//  locarie
//
//  Created by qiuty on 2023/11/1.
//

import SwiftUI

struct BottomSheet<Content: View>: View {
  let content: Content
  let detents: [BottomSheetDetent]

  @State var offsetY: CGFloat = 0
  @State var translation: CGSize = .zero

  @State var screenHeight: CGFloat = 0

  init(
    detents: [BottomSheetDetent] = [.minimum, .medium],
    @ViewBuilder content: () -> Content
  ) {
    if detents.isEmpty {
      self.detents = [.minimum, .medium]
    } else {
      self.detents = detents
    }
    self.content = content()
  }

  var body: some View {
    GeometryReader { proxy in
      VStack {
        handler.gesture(dragGesture(proxy: proxy))
        content
      }
      .frame(width: proxy.size.width, alignment: .top)
      .background(background)
      .offset(y: translation.height + offsetY)
      .onAppear {
        screenHeight = proxy.frame(in: .global).size.height
        offsetY = detents.first!.getOffset(screenHeight: screenHeight)
      }
      .onChange(of: proxy.size) { _, newSize in
        screenHeight = newSize.height
        offsetY = detents.first!.getOffset(screenHeight: screenHeight)
      }
    }
  }

  private var background: some View {
    UnevenRoundedRectangle(
      topLeadingRadius: BottomSheetConstants.backgroundCornerRadius,
      topTrailingRadius: BottomSheetConstants.backgroundCornerRadius
    ).fill(.background)
  }
}

private extension BottomSheet {
  var handler: some View {
    Capsule()
      .fill(.secondary)
      .frame(
        width: BottomSheetConstants.handlerWidth,
        height: BottomSheetConstants.handlerHeight
      )
      .padding(.top, BottomSheetConstants.handlerPaddingTop)
  }

  func dragGesture(proxy _: GeometryProxy) -> some Gesture {
    DragGesture(coordinateSpace: .global)
      .onChanged { value in
        if offsetY != 0 || value.translation.height > 0 {
          translation = value.translation
        }
      }
      .onEnded { _ in
        withAnimation(
          .interactiveSpring(response: 0.5, dampingFraction: 0.6)
        ) {
          offsetY = getOffsetY()
          translation = .zero
        }
      }
  }
}

enum BottomSheetConstants {
  static let backgroundCornerRadius = 20.0
  static let handlerWidth = 60.0
  static let handlerHeight = 5.0
  static let handlerPaddingTop = 15.0
}

#Preview {
  BottomSheet(detents: [.minimum, .medium, .large]) {
    ScrollView {
      VStack {
        ForEach(1 ..< 100, id: \.self) { i in
          HStack {
            Spacer()
            Text("This is text \(i)")
            Spacer()
          }
        }
      }
    }
  }
  .background(.green)
}
