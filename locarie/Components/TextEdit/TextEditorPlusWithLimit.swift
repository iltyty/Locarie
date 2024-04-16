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
      TextEditorPlus(hint: hint, text: $viewModel.text)
      remainingWordCount
    }
    .background(background)
  }

  var background: some View {
    Group {
      if showBorder {
        RoundedRectangle(cornerRadius: Constants.borderCornerRadius)
          .stroke(.secondary)
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
        .foregroundStyle(.secondary)
        .padding()
    }
  }
}

private enum Constants {
  static let borderCornerRadius = 20.0
}

#Preview {
  TextEditorPlusWithLimit(
    viewModel: TextEditViewModel(limit: 500), hint: "Share your feedback..."
  )
}
