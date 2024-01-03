//
//  BusinessRegisterPage.swift
//  locarie
//
//  Created by qiuty on 23/12/2023.
//

import SwiftUI

struct BusinessRegisterPage: View {
  @StateObject var viewModel = RegisterViewModel(type: .business)

  @Binding var path: [Route]

  var body: some View {
    VStack(spacing: Constants.vSpacing) {
      navigationTitle
      businessNameInput
      businessCategoryInput
      businessAddressInput
      createButton
      Spacer()
    }
  }

  private var navigationTitle: some View {
    NavigationTitle("Create a business account").padding(.bottom)
  }

  @ViewBuilder private var businessNameInput: some View {
    let text = "Business name"
    TextFormItem(title: text, hint: text, input: $viewModel.dto.businessName)
  }

  private var businessCategoryInput: some View {
    NavigationLink {
      BusinessCategoryPage($viewModel.dto.category)
    } label: {
      LinkFormItem(
        title: "Business category",
        hint: "Category",
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
      LinkFormItem(
        title: "Business address",
        hint: "Address",
        text: $viewModel.dto.address
      )
    }
    .tint(.primary)
    .buttonStyle(.plain)
  }

  var createButton: some View {
    NavigationLink {
      RegularRegisterPage(path: $path, registerViewModel: viewModel)
    } label: {
      primaryColorFormItemBuilder(text: "Next")
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
  BusinessRegisterPage(path: .constant([]))
}
