//
//  StrokeFormItemBuilder.swift
//  locarie
//
//  Created by qiuty on 20/02/2024.
//

import SwiftUI

func strokeFormItemBuilder(text: String, color: some ShapeStyle) -> some View {
  Text(text)
    .fontWeight(.semibold)
    .background(formItemStrokeBackground(color))
    .padding(.horizontal)
    .frame(
      width: ComponentBuilderConstants.formItemWidth,
      height: ComponentBuilderConstants.formItemHeight
    )
    .tint(color)
}
