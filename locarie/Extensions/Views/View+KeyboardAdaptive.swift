//
//  View+KeyboardAdaptive.swift
//  locarie
//
//  Created by qiuty on 21/06/2024.
//

import Combine
import SwiftUI

struct KeyboardAdaptive: ViewModifier {
  @State private var keyboardHeight: CGFloat = 0

  func body(content: Content) -> some View {
    content
      .padding(.bottom, keyboardHeight)
      .onReceive(Publishers.keyboardHeight) { keyboardHeight = $0 }
  }
}

extension View {
  func keyboardAdaptive() -> some View {
    ModifiedContent(content: self, modifier: KeyboardAdaptive())
  }
}
