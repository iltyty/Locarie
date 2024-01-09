//
//  TextEditorPlus.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct TextEditorPlus: View {
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
      textEditor
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

private extension TextEditorPlus {
  var textEditor: some View {
    ZStack(alignment: .topLeading) {
      if viewModel.text.isEmpty {
        hintPurposeTextEditor
      }
      editPurposeTextEditor
    }
    .padding()
  }

  var hintPurposeTextEditor: some View {
    TextEditor(text: $hint)
      .foregroundStyle(.secondary)
      .disabled(true)
  }

  var editPurposeTextEditor: some View {
    TextEditor(text: $viewModel.text)
      .opacity(viewModel.text.isEmpty ? 0.25 : 1)
  }

  var remainingWordCount: some View {
    HStack {
      Spacer()
      Text("\(viewModel.remainingCount)").padding()
    }
  }
}

private enum Constants {
  static let borderCornerRadius = 20.0
}

#Preview {
  TextEditorPlus(
    viewModel: TextEditViewModel(limit: 500), hint: "Share your feedback..."
  )
}
