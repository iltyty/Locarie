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

  @Binding var currentDetent: BottomSheetDetent

  @State private var screenHeight: CGFloat = 0

  init(
    topPosition: TopPosition = .left,
    detents: [BottomSheetDetent],
    currentDetent: Binding<BottomSheetDetent> = .constant(.minimum),
    @ViewBuilder content: () -> Content,
    @ViewBuilder topContent: () -> TopContent = { EmptyView() }
  ) {
    self.topPosition = topPosition
    self.content = content()
    self.topContent = topContent()
    if detents.isEmpty {
      self.detents = [.minimum, .medium]
    } else {
      self.detents = detents.sorted { d1, d2 in
        d1.getOffset(screenHeight: 1000) < d2.getOffset(screenHeight: 1000)
      }
    }
    _currentDetent = currentDetent
  }

  var body: some View {
    GeometryReader { proxy in
      VStack {
        if currentDetent != .large {
          topContentView
        }
        contentView
      }
      .scrollDisabled(currentDetent != .large)
      .gesture(
        DragGesture(minimumDistance: 10).onEnded { value in
          var index = detents.firstIndex { $0 == currentDetent } ?? 0
          if value.translation.height > 0 {
            index = min(index + 1, detents.count - 1)
          } else {
            index = max(index - 1, 0)
          }
          withAnimation(.spring) {
            currentDetent = detents[index]
          }
        }
      )
      .offset(y: currentDetent.getOffset(screenHeight: screenHeight))
      .onAppear {
        screenHeight = proxy.frame(in: .global).size.height
      }
      .onChange(of: proxy.size) { newSize in
        screenHeight = newSize.height
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
    VStack(spacing: 2) {
      HStack {
        Spacer()
        handler
        Spacer()
      }
      content
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity)
    }
    .contentShape(Rectangle())
    .onTapGesture {
      withAnimation(.spring) {
        currentDetent = .large
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

private struct BottomSheetTestView: View {
  @State var currentDetent: BottomSheetDetent = .medium

  var body: some View {
    BottomSheet(topPosition: .right, detents: [.minimum, .medium, .large], currentDetent: $currentDetent) {
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
}

#Preview {
  BottomSheetTestView()
}
