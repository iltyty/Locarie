//
//  InvitationCodePage.swift
//  Locarie
//
//  Created by qiu on 2024/11/17.
//

import SwiftUI

struct InvitationCodePage: View {
  @State private var code = ""
  
  
  var body: some View {
    VStack {
      NavigationBar("Invitation code")
      Spacer()
      TextEditFormItemWithBlockTitle(title: "Invitation code", hint: "", text: $code)
        .padding(.horizontal, 16)
      Spacer()
      NavigationLink {
        BusinessRegisterPage()
      } label: {
        StrokeButtonFormItem(title: "Next", isFullWidth: true)
          .padding([.bottom, .horizontal], 16)
      }
      .disabled(code != Constants.code)
    }
  }
}

private struct Constants {
  static let code = "826889"
}

#Preview {
  InvitationCodePage()
}
