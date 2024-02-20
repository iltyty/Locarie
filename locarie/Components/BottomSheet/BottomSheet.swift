//
//  BottomSheet.swift
//  locarie
//
//  Created by qiuty on 2023/11/1.
//

import SwiftUI
import UIKit

struct BottomSheet<Content: View>: View {
  let content: Content
  let detents: [BottomSheetDetent]

  @State var offsetY: CGFloat = 0
  @State var translation: CGSize = .zero
  @State var currentDetent: BottomSheetDetent = .minimum

  @State var screenHeight: CGFloat = 0

  init(
    detents: [BottomSheetDetent] = [.minimum, .medium],
    @ViewBuilder content: () -> Content
  ) {
    self.content = content()
    if detents.isEmpty {
      self.detents = [.minimum, .medium]
      currentDetent = .minimum
    } else {
      self.detents = detents
      currentDetent = detents[0]
    }
  }

  var body: some View {
    GeometryReader { proxy in
      VStack {
        handler
        ScrollViewReader { _ in
          ScrollView {
            HStack {
              Spacer()
              content
              Spacer()
            }
          }
        }
        .scrollIndicators(.hidden)
        .scrollDisabled(isScrollDisabled)
        .onAppear {
          UIScrollView.appearance().bounces = false
        }
      }
      .background(background)
      .highPriorityGesture(dragGesture)
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

  private var isScrollDisabled: Bool {
    switch currentDetent {
    case .minimum: true
    default: false
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

  var dragGesture: some Gesture {
    DragGesture(coordinateSpace: .global)
      .onChanged { value in
        if offsetY != 0 || value.translation.height > 0 {
          translation = value.translation
        }
      }
      .onEnded { value in
        withAnimation(
          .interactiveSpring(response: 0.5, dampingFraction: 1)
        ) {
          if value.velocity.height > .init(1000) {
            currentDetent = .minimum
            offsetY = currentDetent.getOffset(screenHeight: screenHeight)
          } else if value.velocity.height < .init(-1000) {
            currentDetent = .large
            offsetY = currentDetent.getOffset(screenHeight: screenHeight)
          } else {
            (currentDetent, offsetY) = getDetentAndOffset()
          }
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
  BottomSheet(detents: [.minimum, .large]) {
    VStack {
      ForEach(1 ..< 100, id: \.self) { i in
        Text("This is text \(i)")
      }
    }
  }
  .background(.green)
}
