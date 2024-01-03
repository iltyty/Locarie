//
//  PlainItemBuilders.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import Foundation
import SwiftUI

func primaryForegroundItemBuilder(text: String) -> some View {
  Text(text)
    .frame(maxWidth: .infinity)
    .foregroundStyle(.white)
    .fontWeight(.bold)
    .background(primaryItemBackground())
    .padding(.horizontal)
    .frame(height: ComponentBuilderConstants.formItemHeight)
}

func whiteForegroundItemBuilder(text: String) -> some View {
  whiteForegroundItemBuilder(label: Text(text))
}

func whiteForegroundItemBuilder(label: some View) -> some View {
  label
    .frame(maxWidth: .infinity)
    .background(whiteItemBackground())
    .padding(.horizontal)
    .frame(height: ComponentBuilderConstants.formItemHeight)
}

private func primaryItemBackground() -> some View {
  RoundedRectangle(cornerRadius: ComponentBuilderConstants.formItemCornerRadius)
    .fill(Color.locariePrimary)
    .frame(height: ComponentBuilderConstants.formItemHeight)
}

private func whiteItemBackground() -> some View {
  RoundedRectangle(cornerRadius: ComponentBuilderConstants.formItemCornerRadius)
    .fill(.white)
    .frame(height: ComponentBuilderConstants.formItemHeight)
    .shadow(radius: ComponentBuilderConstants.formItemBackgroundShadow)
}
