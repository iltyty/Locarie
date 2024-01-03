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
    .frame(height: ComponentBuilderConstants.formItemHeight)
    .shadow(radius: ComponentBuilderConstants.formItemBackgroundShadow)
}
