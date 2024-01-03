//
//  ButtonBuilders.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import Foundation
import SwiftUI

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
