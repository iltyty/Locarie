//
//  Publishers+KeyboardHeight.swift
//  locarie
//
//  Created by qiuty on 21/06/2024.
//

import Combine
import UIKit

extension Publishers {
  static var keyboardHeight: AnyPublisher<CGFloat, Never> {
    let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
      .map(\.keyboardHeight)
    let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
      .map { _ in CGFloat(0) }
    return MergeMany(willShow, willHide)
      .eraseToAnyPublisher()
  }
}
