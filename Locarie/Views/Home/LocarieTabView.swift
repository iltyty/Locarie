//
//  LocarieTabView.swift
//  Locarie
//
//  Created by qiuty on 15/10/2024.
//

import SwiftUI

struct LocarieTabView<Content: View>: View {
  let tabNames: [String]
  let content: () -> Content

  init(_ tabNames: [String], @ViewBuilder content: @escaping () -> Content) {
    self.tabNames = tabNames
    self.content = content
  }

  @State var index = 0
  @Namespace private var tabBarID
  @Namespace private var tabBarNS

  var body: some View {
    VStack(spacing: 0) {
      HStack {
        ForEach(tabNames.indices, id: \.self) { i in
          if i == 0 {
            Spacer()
          }
          tabBuilder(text: tabNames[i], i: i)
          Spacer()
        }
      }
      // Using TabView with page style together with ScrollView
      // will cause weird trembling bug:
      // https://developer.apple.com/forums/thread/730151
//      TabView(
//        selection: Binding<Int>(
//          get: { index },
//          set: { i in
//            withAnimation(.spring(duration: 0.5)) { index = i }
//          }
//        ),
//        content: content
//      )
//      .tabViewStyle(.page(indexDisplayMode: .never))
    }
  }

  private func tabBuilder(text: String, i: Int) -> some View {
    VStack(spacing: 14) {
      Text(text)
        .fontWeight(.bold)
        .foregroundStyle(index == i ? .black : LocarieColor.greyDark)
        .onTapGesture {
          withAnimation(.spring(duration: 0.5)) {
            index = i
          }
        }
      Group {
        if index == i {
          Rectangle().fill(.black).matchedGeometryEffect(id: tabBarID, in: tabBarNS)
        } else {
          Color.clear
        }
      }
      .frame(width: 32, height: 2)
    }
  }
}

#Preview {
  LocarieTabView(["Red", "Green"]) {
    Color.red.tag(0)
    Color.green.tag(1)
  }
}
