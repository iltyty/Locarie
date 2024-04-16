//
//  TextEditorPlus.swift
//  locarie
//
//  Created by qiuty on 16/04/2024.
//

import SwiftUI

struct TextEditorPlus: View {
  @State var hint: String
  @Binding var text: String

  var body: some View {
    ZStack(alignment: .topLeading) {
      if text.isEmpty {
        hintPurposeTextEditor
      }
      editPurposeTextEditor
    }
  }

  var hintPurposeTextEditor: some View {
    TextEditor(text: $hint)
      .foregroundStyle(.secondary)
      .disabled(true)
  }

  var editPurposeTextEditor: some View {
    TextEditor(text: $text)
      .opacity(text.isEmpty ? 0.25 : 1)
  }
}
