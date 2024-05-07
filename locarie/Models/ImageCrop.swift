//
//  ImageCrop.swift
//  locarie
//
//  Created by qiuty on 06/05/2024.
//

import Foundation
import SwiftUI

enum ImageCrop: Equatable {
  case circle(CGFloat)
  case square(CGFloat)
  case rectangle(CGFloat, CGFloat)

  func size() -> CGSize {
    switch self {
    case let .circle(size): CGSize(width: size, height: size)
    case let .square(size): CGSize(width: size, height: size)
    case let .rectangle(width, height): CGSize(width: width, height: height)
    }
  }
}
