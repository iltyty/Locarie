//
//  RegularRegisterPage.swift
//  locarie
//
//  Created by qiuty on 22/12/2023.
//

import SwiftUI

struct RegularRegisterPage: View {
  @Binding var path: [Route]

  @EnvironmentObject var cacheViewModel: LocalCacheViewModel

  @StateObject var registerViewModel = RegisterViewModel()
  @StateObject var loginViewModel = LoginViewModel()

  @State private var isNotificationReceived = false
  @State private var isServiceAgreed = false

  @State private var isLoading = false
  @State private var alertTitle = ""
  @State private var isAlertShowing = false

  var body: some View {
    content
      .disabled(isLoading)
      .overlay { isLoading ? ProgressView() : nil }
      .alert(alertTitle, isPresented: $isAlertShowing) {}
      .onReceive(registerViewModel.$state) { state in
        handleRegisterStateChange(state)
      }
      .onReceive(loginViewModel.$state) { state in
        handleLoginStateChange(state)
      }
  }

  private func handleRegisterStateChange(_ state: RegisterViewModel.State) {
    switch state {
    case .finished:
      handleRegisterFinished()
    case let .failed(error):
      isLoading = false
      handleNetworkError(error)
    default:
      return
    }
  }

  private func handleLoginStateChange(_ state: LoginViewModel.State) {
    switch state {
    case let .finished(info):
      isLoading = false
      handleLoginFinished(info: info)
    case let .failed(error):
      isLoading = false
      handleNetworkError(error)
    default:
      return
    }
  }

  private func handleRegisterFinished() {
    loginViewModel.setDto(from: registerViewModel.dto)
    loginViewModel.login()
  }

  private func handleLoginFinished(info: UserInfo?) {
    guard let info else { return }
    cacheViewModel.setUserInfo(info)
    backToRoot()
  }

  private func handleNetworkError(_ error: NetworkError) {
    isLoading = false
    if let backendError = error.backendError {
      alertTitle = backendError.message
    } else if let initialError = error.initialError {
      alertTitle = initialError.localizedDescription
    } else {
      alertTitle = "Something went wrong, please try again later"
    }
    isAlertShowing = true
  }

  private func backToRoot() {
    path.removeAll()
  }
}

extension RegularRegisterPage {
  var content: some View {
    VStack(spacing: Constants.spacing) {
      navigationTitle
      Spacer()
      emailInput
      firstNameInput
      lastNameInput
      usernameInput
      passwordInput
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

  var usernameInput: some View {
    formItemWithTitleBuilder(
      title: "Username",
      hint: "Username",
      input: $registerViewModel.dto.username,
      isSecure: false
    )
  }

  var passwordInput: some View {
    VStack(alignment: .leading) {
      formItemWithTitleBuilder(
        title: "Password",
        hint: "Password",
        input: $registerViewModel.dto.password,
        isSecure: true
      )
      Text("Minimum 8 characters or numbers.")
        .font(.caption)
        .foregroundStyle(.secondary)
        .padding(.leading)
        .padding(.leading)
    }
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
      registerViewModel.register()
    }
    .disabled(isButtonDisabled)
    .opacity(buttonOpacity)
  }

  var isButtonDisabled: Bool {
    !registerViewModel.isFormValid || !isServiceAgreed
  }

  var buttonOpacity: CGFloat {
    isButtonDisabled ? Constants.buttonDisabledOpacity : 1
  }
}

private extension RegularRegisterPage {
  func textWithPrimaryColor(_ text: String) -> some View {
    Text(text)
      .foregroundStyle(Color.locariePrimary)
      .lineLimit(1)
  }

  func pickerLineImage(
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

private extension RegularRegisterPage {
  func popToRoot() {
    path = []
  }
}

private enum Constants {
  static let spacing = 10.0
  static let pickerLineImageSpacing = 10.0
  static let buttonDisabledOpacity = 0.5
}

#Preview {
  RegularRegisterPage(
    path: .constant([]),
    registerViewModel: RegisterViewModel()
  )
  .environmentObject(LocalCacheViewModel())
}
