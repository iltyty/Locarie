//
//  RegularRegisterPage.swift
//  locarie
//
//  Created by qiuty on 22/12/2023.
//

import SwiftUI

struct RegularRegisterPage: View {
  @StateObject var registerViewModel = UserRegisterViewModel()

  @State var isNotificationReceived = false
  @State var isServiceAgreed = false

  var body: some View {
    VStack(spacing: Constants.spacing) {
      navigationTitle
      Spacer()
      emailInput
      firstNameInput
      lastNameInput
      passwordInput
      confirmPasswordInput
      notificationPicker
      servicePicker
      Spacer()
      createButton
      Spacer()
    }
  }

  var navigationTitle: some View {
    Text("Create an account")
      .font(.headline)
      .fontWeight(.bold)
  }

  var emailInput: some View {
    formItemWithTitleBuilder(
      title: "Email",
      hint: "Email",
      input: $registerViewModel.dto.email,
      isSecure: false
    )
  }

  var firstNameInput: some View {
    formItemWithTitleBuilder(
      title: "First name",
      hint: "First name",
      input: $registerViewModel.dto.firstName,
      isSecure: false
    )
  }

  var lastNameInput: some View {
    formItemWithTitleBuilder(
      title: "Last name",
      hint: "Last name",
      input: $registerViewModel.dto.lastName,
      isSecure: false
    )
  }

  var passwordInput: some View {
    VStack(alignment: .leading) {
      formItemWithTitleBuilder(
        title: "Password",
        hint: "Password",
        input: $registerViewModel.dto.password,
        isSecure: false
      )
      Text("Minimum 8 characters or numbers.")
        .font(.caption)
        .foregroundStyle(.secondary)
        .padding(.leading)
        .padding(.leading)
    }
  }

  var confirmPasswordInput: some View {
    formItemWithTitleBuilder(
      title: "Confirm password",
      hint: "Confirm password",
      input: $registerViewModel.dto.confirmPassword,
      isSecure: false
    )
    .padding(.bottom)
  }

  var notificationPicker: some View {
    let systemName = isNotificationReceived ? "circle.fill" : "circle"
    return HStack(alignment: .top, spacing: Constants.pickerLineImageSpacing) {
      pickerLineImage(systemName: systemName, isFilled: $isNotificationReceived)
      Text("I do not wish to receive notifications with updates and news.")
      Spacer()
    }
    .padding(.horizontal)
    .font(.caption)
  }

  var servicePicker: some View {
    let systemName = isServiceAgreed ? "circle.fill" : "circle"
    return HStack(alignment: .top, spacing: Constants.pickerLineImageSpacing) {
      pickerLineImage(systemName: systemName, isFilled: $isServiceAgreed)
      WrappingHStack(hSpacing: 0) {
        Text("I agree to the ").fixedSize(horizontal: true, vertical: false)
        textWithPrimaryColor("Privacy Policy")
        Text(", ")
        textWithPrimaryColor("Terms of use")
        Text(", ")
        textWithPrimaryColor("Community Guidelines")
        Text(", and ")
        textWithPrimaryColor("Terms of Service")
        Text(".")
        Spacer()
      }
    }
    .padding(.horizontal)
    .font(.caption)
  }

  var createButton: some View {
    primaryButtonBuilder(text: "Create Account") {
      print("create button tapped")
    }
  }
}

extension RegularRegisterPage {
  private func textWithPrimaryColor(_ text: String) -> some View {
    Text(text)
      .foregroundStyle(Color.locariePrimary)
      .lineLimit(1)
  }

  private func pickerLineImage(
    systemName: String,
    isFilled: Binding<Bool>
  ) -> some View {
    Image(systemName: systemName)
      .foregroundStyle(Color.locariePrimary)
      .onTapGesture {
        isFilled.wrappedValue.toggle()
      }
  }
}

private enum Constants {
  static let spacing = 10.0
  static let pickerLineImageSpacing = 10.0
}

#Preview {
  RegularRegisterPage()
}
