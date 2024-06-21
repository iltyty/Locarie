//
//  Notification+KeyboardHeight.swift
//  locarie
//
//  Created by qiuty on 21/06/2024.
//

import UIKit

extension Notification {
  var keyboardHeight: CGFloat {
    (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
  }
}
