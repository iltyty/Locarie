//
//  UINavigationController+NavigationBarHidden.swift
//  locarie
//
//  Created by qiuty on 17/01/2024.
//

import UIKit

extension UINavigationController {
  override open func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    navigationBar.isHidden = true
  }

  public func gestureRecognizer(
    _: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer
  ) -> Bool {
    true
  }
}
