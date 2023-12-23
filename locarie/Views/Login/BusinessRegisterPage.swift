//
//  BusinessRegisterPage.swift
//  locarie
//
//  Created by qiuty on 23/12/2023.
//

import SwiftUI

struct BusinessRegisterPage: View {
  @StateObject var registerViewModel = BusinessUserRegisterViewModel()

  var body: some View {
    NavigationView {
      VStack(spacing: 50) {
        navigationTitle
        businessNameInput
        businessCategoryInput
        businessAddressInput
        nextButton
        Spacer()
      }
    }
  }

  var navigationTitle: some View {
    navigationTitleBuilder(title: "Create a business account")
      .padding(.bottom)
  }

  var businessNameInput: some View {
    let text = "Business name"
    return formItemWithTitleBuilder(
      title: text, hint: text, input: $registerViewModel.dto.businessName,
      isSecure: false
    )
  }

  var businessCategoryInput: some View {
    NavigationLink {
      BusinessCategoryPage()
    } label: {
      formItemWithTitleBuilder(
        title: "Business category",
        hint: "Category",
        input: $registerViewModel.dto.businessCategory,
        isSecure: false
      )
      .disabled(true)
    }
    .tint(.primary)
    .buttonStyle(.plain)
  }

  var businessAddressInput: some View {
    NavigationLink {
      BusinessAddressPage()
    } label: {
      formItemWithTitleBuilder(
        title: "Business Address",
        hint: "Address",
        input: $registerViewModel.dto.businessAddress,
        isSecure: false
      )
      .disabled(true)
    }
    .tint(.primary)
    .buttonStyle(.plain)
  }

  var nextButton: some View {
    NavigationLink {
      BusinessCategoryPage()
    } label: {
      primaryForegroundItemBuilder(text: "Next")
    }
  }
}

#Preview {
  BusinessRegisterPage()
}
