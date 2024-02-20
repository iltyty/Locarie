//
//  BusinessRegisterPage.swift
//  locarie
//
//  Created by qiuty on 23/12/2023.
//

import SwiftUI

struct BusinessRegisterPage: View {
  @StateObject var viewModel = RegisterViewModel(type: .business)

  var body: some View {
    VStack(spacing: Constants.vSpacing) {
      navigationTitle
      businessNameInput
      businessCategoryInput
      businessAddressInput
      Spacer()
      nextButton
    }
    .padding(.horizontal)
  }

  private var navigationTitle: some View {
    NavigationTitle("Create a business account").padding(.bottom)
  }

  @ViewBuilder private var businessNameInput: some View {
    let text = "Business name"
    TextEditFormItemWithBlockTitle(
      title: text,
      hint: text,
      text: $viewModel.dto.businessName
    )
  }

  private var businessCategoryInput: some View {
    NavigationLink {
      BusinessCategoryPage($viewModel.dto.category)
    } label: {
      LinkFormItemWithBlockTitle(
        title: "Business category",
        hint: "Select your category",
        text: $viewModel.dto.category
      )
    }
    .tint(.primary)
    .buttonStyle(.plain)
  }

  private var businessAddressInput: some View {
    NavigationLink {
      BusinessAddressPage(
        address: $viewModel.dto.address,
        location: $viewModel.dto.location
      )
    } label: {
      LinkFormItemWithBlockTitle(
        title: "Business address",
        hint: "Address",
        text: $viewModel.dto.address
      )
    }
    .tint(.primary)
    .buttonStyle(.plain)
  }

  var nextButton: some View {
    NavigationLink {
      RegularRegisterPage(registerViewModel: viewModel)
    } label: {
      StrokeButtonFormItem(title: "Next step")
        .padding(.bottom)
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
  static let vSpacing: CGFloat = 16
  static let buttonDisabledOpacity: CGFloat = 0.5
}

#Preview {
  BusinessRegisterPage()
    .environmentObject(Router.shared)
}
