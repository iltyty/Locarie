//
//  View+KeyboardAdaptive.swift
//  locarie
//
//  Created by qiuty on 21/06/2024.
//

import Combine
import SwiftUI

public extension Publishers {
  static var keyboardHeight: AnyPublisher<CGFloat, Never> {
    let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
      .map(\.keyboardHeight)
    let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
      .map { _ in CGFloat(0) }

    return MergeMany(willShow, willHide)
      .eraseToAnyPublisher()
  }
}

public extension Notification {
  var keyboardHeight: CGFloat {
    (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
  }
}

public struct KeyboardAvoiding: ViewModifier {
  @State private var keyboardActiveAdjustment: CGFloat = 0

  public func body(content: Content) -> some View {
    content
      .safeAreaInset(edge: .bottom, spacing: keyboardActiveAdjustment) {
        EmptyView().frame(height: 0)
      }
      .onReceive(Publishers.keyboardHeight) {
        keyboardActiveAdjustment = min($0, 32)
      }
  }
}

public extension View {
  func keyboardAdaptive() -> some View {
    modifier(KeyboardAvoiding())
  }
}
