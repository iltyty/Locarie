//
//  InputFormItemBuilder.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import Foundation
import SwiftUI

func inputFormItemBuilder(
  hint: String,
  input: Binding<String>,
  isFocused: FocusState<Bool>.Binding,
  isSecure: Bool,
  showIcon: Bool
) -> some View {
  HStack {
    formItemTextField(
      hint: hint,
      input: input,
      isFocused: isFocused,
      isSecure: isSecure
    )
    Spacer()
    if showIcon {
      Image(systemName: "square.and.pencil")
        .onTapGesture {
          isFocused.wrappedValue = true
        }
    }
  }
  .padding(.horizontal)
  .textInputAutocapitalization(.never)
  .background(formItemBackground(.background))
  .padding(.horizontal)
  .frame(height: ComponentBuilderConstants.formItemHeight)
}

private func formItemTextField(
  hint: String,
  input: Binding<String>,
  isFocused: FocusState<Bool>.Binding,
  isSecure: Bool = false
) -> some View {
  Group {
    if isSecure {
      SecureField(hint, text: input)
    } else {
      TextField(hint, text: input)
    }
  }
  .focused(isFocused)
}
