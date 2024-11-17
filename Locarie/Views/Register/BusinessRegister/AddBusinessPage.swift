//
//  AddBusinessPage.swift
//  Locarie
//
//  Created by qiu on 2024/11/17.
//

import SwiftUI

struct AddBusinessPage: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      NavigationBar("Add your business")
      Spacer()
      Text("Add your business on Locarie")
        .foregroundStyle(LocarieColor.primary)
        .fontWeight(.bold)
        .font(.custom(GlobalConstants.fontName, size: 20))
        .padding(.horizontal, 32)
      Text("If you are interested in joining, fill out this form below and we will get back to you as soom as possible.")
        .padding(.horizontal, 32)
      Text("Learn more on www.locarie.com")
        .padding(.horizontal, 32)
        .tint(LocarieColor.blue)
      Link(destination: URL(string: Constants.signupURL)!) {
        Text("Sign up for free")
          .fontWeight(.bold)
          .foregroundStyle(.white)
          .frame(height: 48)
          .frame(maxWidth: .infinity)
          .background {
            Rectangle().fill(LocarieColor.primary)
          }
          .padding(.horizontal, 32)
      }
      Spacer()
      HStack {
        Spacer()
        NavigationLink {
          InvitationCodePage()
        } label: {
          Text("Type in invitation code")
            .foregroundStyle(LocarieColor.blue)
            .padding(.bottom, 20)
            .padding(.horizontal, 32)
        }
        Spacer()
      }
    }
  }
}

private struct Constants {
  static let signupURL = "https://www.locarie.com/sign-up"
}

#Preview {
  AddBusinessPage()
}
