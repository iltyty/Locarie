//
//  UIImage+downsampling.swift
//  Locarie
//
//  Created by qiu on 2024/11/24.
//

import UIKit
import SwiftUI

public extension UIImage {
  func downsampling(scale: CGFloat) -> UIImage {
    let width = self.size.width * scale
    let height = self.size.height * scale
    let size = CGSize(width: width, height: height)
    let renderer = UIGraphicsImageRenderer(size: size)
    
    return renderer.image { _ in
      self.draw(in: CGRect(origin: .zero, size: size))
    }
  }
}
