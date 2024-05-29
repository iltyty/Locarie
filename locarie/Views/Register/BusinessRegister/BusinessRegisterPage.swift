//
//  BusinessRegisterPage.swift
//  locarie
//
//  Created by qiuty on 23/12/2023.
//

import SwiftUI

struct BusinessRegisterPage: View {
  @StateObject var viewModel = RegisterViewModel(type: .business)

  @FocusState private var focused: Bool

  var body: some View {
    GeometryReader { _ in
      VStack(spacing: 0) {
        navigationBar
        content.ignoresSafeArea(.keyboard)
      }
      .ignoresSafeArea(.keyboard)
    }
    .keyboardDismissable(focus: $focused)
  }

  private var content: some View {
    VStack(spacing: Constants.vSpacing) {
      Spacer()
      businessNameInput
      businessCategoryInput
      businessAddressInput
      Spacer()
      nextButton
    }
    .padding(.horizontal)
  }

  private var navigationBar: some View {
    NavigationBar("Create a business account")
  }

  @ViewBuilder private var businessNameInput: some View {
    let text = "Business name"
    TextEditFormItemWithBlockTitle(
      title: text,
      hint: text,
      text: $viewModel.dto.businessName
    )
    .focused($focused)
  }

  private var businessCategoryInput: some View {
    NavigationLink {
      BusinessCategoryPage(categories: $viewModel.dto.categories)
    } label: {
      LinkFormItemWithBlockTitle(
        title: "Business category",
        hint: "Select your category",
        textArray: $viewModel.dto.categories
      )
    }
    .tint(.primary)
    .buttonStyle(.plain)
  }

  private var businessAddressInput: some View {
    NavigationLink {
      BusinessAddressPage(dto: $viewModel.dto)
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
