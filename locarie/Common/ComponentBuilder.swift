//
//  ComponentBuilder.swift
//  locarie
//
//  Created by qiuty on 22/12/2023.
//

import Foundation
import SwiftUI

func navigationTitleBuilder(
  title: String,
  left: some View = defaultNavigationLeftView(),
  right: some View = EmptyView()
) -> some View {
  ZStack(alignment: .top) {
    HStack {
      left
      Spacer()
      right
    }
    Text(title)
      .font(.headline)
      .fontWeight(.bold)
  }
}

private func defaultNavigationLeftView() -> some View {
  Image(systemName: "chevron.left")
    .padding(.leading)
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

func whiteButtonBuilder(
  text: String,
  action: @escaping () -> Void
) -> some View {
  whiteButtonBuilder(label: Text(text), action: action)
}

func whiteButtonBuilder(
  label: some View,
  action: @escaping () -> Void
) -> some View {
  Button {
    action()
  } label: {
    whiteForegroundItemBuilder(label: label)
  }
}

func whiteForegroundItemBuilder(text: String) -> some View {
  whiteForegroundItemBuilder(label: Text(text))
}

func whiteForegroundItemBuilder(label: some View) -> some View {
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

func defaultAvatar(size: CGFloat) -> some View {
  Circle()
    .fill(LinearGradient(
      colors: [.locariePrimary, .locariePrimary.opacity(0.5)],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    ))
    .frame(width: size, height: size)
}

private enum Constants {
  static let formItemHeight = 48.0
  static let formItemCornerRadius = 25.0
  static let formItemBackgroundShadow = 2.0
}
