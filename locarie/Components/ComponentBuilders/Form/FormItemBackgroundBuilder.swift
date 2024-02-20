//
//  FormItemBackgroundBuilder.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import Foundation
import SwiftUI

func formItemBackground(_ color: some ShapeStyle) -> some View {
  RoundedRectangle(cornerRadius: ComponentBuilderConstants.formItemCornerRadius)
    .fill(color)
    .frame(
      width: ComponentBuilderConstants.formItemWidth,
      height: ComponentBuilderConstants.formItemHeight
    )
}

func formItemStrokeBackground(_ color: some ShapeStyle) -> some View {
  RoundedRectangle(cornerRadius: ComponentBuilderConstants.formItemCornerRadius)
    .stroke(color)
    .frame(
      width: ComponentBuilderConstants.formItemWidth,
      height: ComponentBuilderConstants.formItemHeight
    )
}
