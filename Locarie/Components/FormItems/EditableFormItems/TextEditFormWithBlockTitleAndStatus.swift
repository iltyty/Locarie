//
//  TextEditFormWithBlockTitleAndStatus.swift
//  locarie
//
//  Created by qiuty on 07/07/2024.
//

import SwiftUI

struct TextEditFormItemWithBlockTitleAndStatus: View {
  let title: String
  let hint: String
  var note = ""
  let valid: Bool
  var isSecure = false

  @Binding var text: String

  @State private var showingSecure = false

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(title)
        .padding(.bottom, 16)
        .padding(.horizontal, FormItemCommonConstants.hPadding)
      HStack(spacing: 0) {
        Group {
          if !isSecure || showingSecure {
            TextField(hint, text: $text, prompt: Text(hint).foregroundColor(LocarieColor.greyDark))
          } else {
            SecureField(hint, text: $text, prompt: Text(hint).foregroundColor(LocarieColor.greyDark))
          }
        }
        .textInputAutocapitalization(.never)
        .frame(height: FormItemCommonConstants.height)
        .padding(.leading, FormItemCommonConstants.hPadding)
        Spacer()
        if isSecure, !text.isEmpty {
          Image(showingSecure ? "Eye" : "Eye.Grey")
            .resizable()
            .scaledToFit()
            .frame(size: 23)
            .contentShape(Rectangle())
            .onTapGesture {
              showingSecure.toggle()
            }
        }
        Circle()
          .fill(valid ? LocarieColor.green : LocarieColor.red)
          .frame(size: 8)
          .padding(.horizontal, 16)
      }
      .background {
        RoundedRectangle(cornerRadius: FormItemCommonConstants.cornerRadius)
          .strokeBorder(FormItemCommonConstants.strokeColor, style: .init(lineWidth: 1.5))
          .padding(0.75)
      }
      FormItemNoteView(note)
    }
  }
}

private struct TestView: View {
  @State private var firstName = ""
  @State private var password = ""
  @State private var valid = false

  var body: some View {
    VStack {
      TextEditFormItemWithBlockTitleAndStatus(
        title: "First Name",
        hint: "First Name",
        valid: valid,
        text: $firstName
      )
      TextEditFormItemWithBlockTitleAndStatus(
        title: "Password",
        hint: "Password",
        note: "Maximum 20 letters",
        valid: valid,
        isSecure: true,
        text: $password
      )
    }
  }
}

#Preview {
  TestView()
}
