//
//  TextEditorPlus.swift
//  locarie
//
//  Created by qiuty on 16/04/2024.
//

import SwiftUI

struct TextEditorPlus: View {
  @Binding var text: String
  @State var hint: String
  @State var border = false

  var body: some View {
    ZStack(alignment: .topLeading) {
      if text.isEmpty {
        hintPurposeTextEditor
      }
      editPurposeTextEditor
    }
  }

  private var hintPurposeTextEditor: some View {
    TextEditor(text: $hint)
      .foregroundStyle(LocarieColor.greyDark)
      .disabled(true)
  }

  private var editPurposeTextEditor: some View {
    TextEditor(text: $text)
      .opacity(text.isEmpty ? 0.25 : 1)
      .background(background)
  }

  @ViewBuilder
  private var background: some View {
    if border {
      RoundedRectangle(cornerRadius: Constants.cornerRadius).strokeBorder(LocarieColor.greyMedium)
    } else {
      Color.clear
    }
  }
}

private enum Constants {
  static let cornerRadius: CGFloat = 25
}

#Preview {
  TextEditorPlus(text: .constant(""), hint: "Hint", border: true)
    .padding()
}
