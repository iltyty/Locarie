//
//  BottomDrawerView.swift
//  locarie
//
//  Created by qiuty on 2023/11/1.
//

import SwiftUI

struct BottomDrawerView<Content: View>: View {
  let content: Content

  @State var offsetY: CGFloat = 0
  @State var translation: CGSize = .zero

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  init(offsetY: CGFloat, @ViewBuilder content: () -> Content) {
    self.content = content()
    self.offsetY = offsetY
  }

  var body: some View {
    GeometryReader { proxy in
      VStack {
        handler
        ScrollView {
          content
        }
      }
      .onAppear {
        print(proxy.size)
      }
      .frame(width: proxy.size.width, alignment: .top)
      .background(.white)
      .mask(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
      .offset(y: translation.height + offsetY)
      .gesture(dragGesture(proxy: proxy))
      .ignoresSafeArea(edges: .bottom)
    }
  }

  private var handler: some View {
    Capsule(style: .circular)
      .fill(.secondary)
      .frame(
        width: Constants.handlerWidth,
        height: Constants.handlerHeight
      )
      .padding(.top, Constants.handlerPaddingTop)
  }

  func dragGesture(proxy: GeometryProxy) -> some Gesture {
    DragGesture()
      .onChanged { value in
        if offsetY != 0 || value.translation.height > 0 {
          translation = value.translation
        }
      }
      .onEnded { _ in
        withAnimation(
          .interactiveSpring(response: 0.5, dampingFraction: 0.6)
        ) {
          let snap = translation.height
          let quarter = proxy.size.height / 4
          if snap > quarter {
            offsetY = 2 * quarter
          } else if -snap > quarter {
            offsetY = 0
          }
          translation = .zero
        }
      }
  }
}

private struct ContentView: View {
  var body: some View {
    ScrollView {
      VStack {
        ForEach(1 ..< 100, id: \.self) { i in
          Text("\(i)").frame(width: .infinity)
        }
      }
    }
  }
}

private enum Constants {
  static let handlerWidth: CGFloat = 80
  static let handlerHeight: CGFloat = 5
  static let handlerPaddingTop: CGFloat = 15
  static let handlerCorderRadius: CGFloat = 20
}

#Preview {
  BottomDrawerView(offsetY: 200) {
    ContentView()
  }
  .background(.blue)
}
