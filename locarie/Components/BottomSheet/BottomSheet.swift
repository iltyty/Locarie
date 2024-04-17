//
//  BottomSheet.swift
//  locarie
//
//  Created by qiuty on 2023/11/1.
//

import SwiftUI
import UIKit

struct BottomSheet<Content: View, TopContent: View>: View {
  let content: Content
  let topContent: TopContent
  let topPosition: TopPosition
  let detents: [BottomSheetDetent]

  @State var offsetY: CGFloat = 0
  @State var translation: CGSize = .zero
  @State var currentDetent: BottomSheetDetent = .minimum
  @State var presentingTopContent = true
  @State var screenHeight: CGFloat = 0

  init(
    topPosition: TopPosition = .left,
    detents: [BottomSheetDetent],
    @ViewBuilder content: () -> Content,
    @ViewBuilder topContent: () -> TopContent = { EmptyView() }
  ) {
    self.topPosition = topPosition
    self.content = content()
    self.topContent = topContent()
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
        if presentingTopContent {
          topContentView
        }
        contentView
      }
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
}

private extension BottomSheet {
  var topContentView: some View {
    HStack {
      if case topPosition = .right {
        Spacer()
      }
      topContent.padding(.horizontal)
      if case topPosition = .left {
        Spacer()
      }
    }
  }

  var contentView: some View {
    VStack {
      HStack {
        Spacer()
        handler
        Spacer()
      }
      .gesture(dragGesture)
      HStack {
        Spacer()
        content
        Spacer()
      }
    }
    .background(background)
  }

  var background: some View {
    UnevenRoundedRectangle(
      topLeadingRadius: BottomSheetConstants.backgroundCornerRadius,
      topTrailingRadius: BottomSheetConstants.backgroundCornerRadius
    ).fill(.background)
  }
}

private extension BottomSheet {
  var handler: some View {
    VStack {
      Capsule()
        .fill(Color(hex: BottomSheetConstants.handlerColor))
        .frame(width: BottomSheetConstants.handlerWidth, height: BottomSheetConstants.handlerHeight)
    }
    .frame(height: BottomSheetConstants.handlerBgHeight)
  }

  var dragGesture: some Gesture {
    DragGesture(coordinateSpace: .global)
      .onChanged { value in
        if translation.height + offsetY <= 100 {
          withAnimation {
            presentingTopContent = false
          }
        } else {
          withAnimation {
            presentingTopContent = true
          }
        }
        if offsetY != 0 || value.translation.height > 0 {
          translation = value.translation
        }
      }
      .onEnded { _ in
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 1)) {
          (currentDetent, offsetY) = getDetentAndOffset()
          if translation.height + offsetY <= 0 {
            withAnimation {
              presentingTopContent = false
            }
          }
          translation = .zero
        }
      }
  }
}

extension BottomSheet {
  enum TopPosition {
    case left, right
  }
}

enum BottomSheetConstants {
  static let backgroundCornerRadius = 20.0
  static let handlerColor: UInt = 0xD9D9D9
  static let handlerWidth = 48.0
  static let handlerHeight = 6.0
  static let handlerBgHeight = 24.0
  static let speedThreshold = 1000.0
}

#Preview {
  BottomSheet(topPosition: .right, detents: [.minimum, .large]) {
    ScrollView {
      VStack {
        ForEach(1 ..< 100, id: \.self) { i in
          Text("This is text \(i)")
        }
      }
    }
  } topContent: {
    Image("NavigationIcon")
      .resizable()
      .scaledToFill()
      .frame(width: 50, height: 50)
  }
  .background(.green)
}
