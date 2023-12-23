//
//  LoginRegisterComponentBuilder.swift
//  locarie
//
//  Created by qiuty on 22/12/2023.
//

import Foundation
import SwiftUI

func navigationTitleBuilder(title: String) -> some View {
  HStack {
    Image(systemName: "chevron.left")
      .padding(.leading)
    Spacer()
    Text(title)
      .font(.headline)
      .fontWeight(.bold)
    Spacer()
  }
}

func formItemBuilder(
  hint: String,
  input: Binding<String>,
  isSecure: Bool
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
  .background(
    RoundedRectangle(cornerRadius: Constants.formItemCornerRadius)
      .fill(.background)
      .frame(height: Constants.formItemHeight)
      .shadow(radius: Constants.formItemBackgroundShadow)
  )
  .padding(.horizontal)
  .frame(height: Constants.formItemHeight)
}

func formItemWithTitleBuilder(
  title: String,
  hint: String,
  input: Binding<String>,
  isSecure: Bool
) -> some View {
  VStack(alignment: .leading) {
    Text(title)
      .padding(.leading)
    formItemBuilder(hint: hint, input: input, isSecure: isSecure)
  }
}

func primaryForegroundItemBuilder(text: String) -> some View {
  Text(text)
    .frame(maxWidth: .infinity)
    .foregroundStyle(.white)
    .fontWeight(.bold)
    .background(
      RoundedRectangle(cornerRadius: Constants.formItemCornerRadius)
        .fill(Color.locariePrimary)
        .frame(height: Constants.formItemHeight)
    )
    .padding(.horizontal)
    .frame(height: Constants.formItemHeight)
}

func primaryButtonBuilder(
  text: String,
  action: @escaping () -> Void
) -> some View {
  Button {
    action()
  } label: {
    primaryForegroundItemBuilder(text: text)
  }
}

func whiteButtonBuilder(
  label: Label<some View, some View>,
  action: @escaping () -> Void
) -> some View {
  Button {
    action()
  } label: {
    label
      .frame(maxWidth: .infinity)
      .background(
        RoundedRectangle(cornerRadius: Constants.formItemCornerRadius)
          .fill(.white)
          .frame(height: Constants.formItemHeight)
          .shadow(radius: Constants.formItemBackgroundShadow)
      )
      .padding(.horizontal)
      .frame(height: Constants.formItemHeight)
  }
}

private enum Constants {
  static let formItemHeight = 48.0
  static let formItemCornerRadius = 25.0
  static let formItemBackgroundShadow = 2.0
}
