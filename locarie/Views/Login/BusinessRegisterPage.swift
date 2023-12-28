//
//  BusinessRegisterPage.swift
//  locarie
//
//  Created by qiuty on 23/12/2023.
//

import SwiftUI

struct BusinessRegisterPage: View {
  @StateObject var viewModel = RegisterViewModel()

  var body: some View {
    NavigationView {
      VStack(spacing: Constants.vSpacing) {
        navigationTitle
        businessNameInput
        businessCategoryInput
        businessAddressInput
        createButton
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
      title: text, hint: text, input: $viewModel.dto.businessName,
      isSecure: false
    )
  }

  var businessCategoryInput: some View {
    NavigationLink {
      BusinessCategoryPage($viewModel.dto.category)
    } label: {
      formItemWithTitleBuilder(
        title: "Business category",
        hint: "Category",
        input: $viewModel.dto.category,
        isSecure: false
      )
      .disabled(true)
    }
    .tint(.primary)
    .buttonStyle(.plain)
  }

  var businessAddressInput: some View {
    NavigationLink {
      BusinessAddressPage(
        address: $viewModel.dto.address,
        location: $viewModel.dto.location
      )
    } label: {
      formItemWithTitleBuilder(
        title: "Business Address",
        hint: "Address",
        input: $viewModel.dto.address,
        isSecure: false
      )
      .disabled(true)
    }
    .tint(.primary)
    .buttonStyle(.plain)
  }

  var createButton: some View {
    NavigationLink {
      RegularRegisterPage(registerViewModel: viewModel)
    } label: {
      primaryForegroundItemBuilder(text: "Create Account")
        .disabled(isButtonDisabled)
        .opacity(buttonOpacity)
    }
  }

  var isButtonDisabled: Bool {
    !viewModel.isBusinessFormValid
  }

  var buttonOpacity: CGFloat {
    isButtonDisabled ? Constants.buttonDisabledOpacity : 1
  }
}

private enum Constants {
  static let vSpacing = 50.0
  static let buttonDisabledOpacity = 0.5
}

#Preview {
  BusinessRegisterPage()
}
