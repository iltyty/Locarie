//
//  BusinessRegisterPage.swift
//  locarie
//
//  Created by qiuty on 23/12/2023.
//

import SwiftUI

struct BusinessRegisterPage: View {
  @StateObject var vm = RegisterViewModel(type: .business)

  @FocusState private var focused: Bool

  var body: some View {
    GeometryReader { _ in
      VStack(spacing: 0) {
        NavigationBar("Create a business account")
        content
          .keyboardDismissable(focus: $focused)
          .ignoresSafeArea(.keyboard)
      }
      .ignoresSafeArea(.keyboard)
    }
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

  @ViewBuilder private var businessNameInput: some View {
    let text = "Business name"
    TextEditFormItemWithBlockTitleAndStatus(
      title: text,
      hint: text,
      note: "Maximum 25 letters.",
      valid: vm.isBusinessNameValid,
      text: $vm.dto.businessName
    )
    .focused($focused)
  }

  private var businessCategoryInput: some View {
    NavigationLink {
      BusinessCategoryPage(categories: $vm.dto.categories)
    } label: {
      LinkFormItemWithBlockTitle(
        title: "Business category",
        hint: "Select your category",
        textArray: $vm.dto.categories
      )
    }
    .tint(.primary)
    .buttonStyle(.plain)
  }

  private var businessAddressInput: some View {
    NavigationLink {
      BusinessAddressPage(dto: $vm.dto)
    } label: {
      LinkFormItemWithBlockTitle(
        title: "Business address",
        hint: "Address",
        text: $vm.dto.address
      )
    }
    .tint(.primary)
    .buttonStyle(.plain)
  }

  var nextButton: some View {
    NavigationLink {
      RegularRegisterPage(isBusinessUser: true, registerViewModel: vm)
    } label: {
      StrokeButtonFormItem(
        title: "Next step",
        color: vm.isBusinessFormValid ? LocarieColor.primary : LocarieColor.greyDark
      )
      .padding(.bottom)
    }
    .buttonStyle(.plain)
    .allowsHitTesting(vm.isBusinessFormValid)
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
