//
//  FormItemBuilders.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import Foundation
import SwiftUI

func formItemWithTitleBuilder(
  title: String,
  hint: String,
  input: Binding<String>,
  isSecure: Bool = false
) -> some View {
  VStack(alignment: .leading) {
    Text(title)
      .padding(.leading)
    formItemBuilder(hint: hint, input: input, isSecure: isSecure)
  }
}

func formItemBuilder(
  hint: String,
  input: Binding<String>,
  isSecure: Bool = false
) -> some View {
  Group {
    if isSecure {
      SecureField(hint, text: input)
    } else {
      TextField(hint, text: input)
    }
  }
  .padding(.horizontal)
  .textInputAutocapitalization(.never)
  .background(formItemBackground())
  .padding(.horizontal)
  .frame(height: ComponentBuilderConstants.formItemHeight)
}

private func formItemBackground() -> some View {
  RoundedRectangle(cornerRadius: ComponentBuilderConstants.formItemCornerRadius)
    .fill(.background)
    .frame(height: ComponentBuilderConstants.formItemHeight)
    .shadow(radius: ComponentBuilderConstants.formItemBackgroundShadow)
}
