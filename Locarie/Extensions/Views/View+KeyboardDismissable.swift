//
//  View+KeyboardDismissable.swift
//  locarie
//
//  Created by qiuty on 29/05/2024.
//

import SwiftUI

extension View {
  func keyboardDismissable(focus: FocusState<(some Hashable)?>.Binding) -> some View {
    background {
      Color.clear.contentShape(Rectangle()).onTapGesture {
        focus.wrappedValue = nil
      }
    }
  }

  func keyboardDismissable(focus: FocusState<Bool>.Binding) -> some View {
    background {
      Color.clear.contentShape(Rectangle()).onTapGesture {
        focus.wrappedValue = false
      }
    }
  }
}
