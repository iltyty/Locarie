//
//  TextEditorPlusWithLimit.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct TextEditorPlusWithLimit: View {
  @ObservedObject var viewModel: TextEditViewModel
  @State var hint: String
  let showBorder: Bool

  init(
    viewModel: TextEditViewModel,
    hint: String,
    border showBorder: Bool = false
  ) {
    self.viewModel = viewModel
    self.hint = hint
    self.showBorder = showBorder
  }

  var body: some View {
    VStack {
      TextEditorPlus(text: $viewModel.text, hint: hint)
      remainingWordCount.padding(Constants.textPadding)
    }
    .padding(Constants.textPadding)
    .overlay(overlay)
  }

  var overlay: some View {
    Group {
      if showBorder {
        RoundedRectangle(cornerRadius: Constants.borderCornerRadius)
          .strokeBorder(LocarieColor.greyMedium)
      } else {
        Color.clear
      }
    }
  }
}

private extension TextEditorPlusWithLimit {
  var remainingWordCount: some View {
    HStack {
      Spacer()
      Text("\(viewModel.text.count)/\(viewModel.limit)")
        .foregroundStyle(LocarieColor.greyDark)
    }
  }
}

private enum Constants {
  static let borderCornerRadius: CGFloat = 25
  static let textPadding: CGFloat = 5
}

#Preview {
  TextEditorPlusWithLimit(
    viewModel: TextEditViewModel(limit: 500),
    hint: "Share your feedback...",
    border: true
  )
  .padding()
}
