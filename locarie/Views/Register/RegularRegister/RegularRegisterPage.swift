//
//  RegularRegisterPage.swift
//  locarie
//
//  Created by qiuty on 22/12/2023.
//

import SwiftUI

struct RegularRegisterPage: View {
  @ObservedObject var router = Router.shared

  @StateObject var cacheViewModel = LocalCacheViewModel.shared
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
    case let .finished(cache):
      isLoading = false
      handleLoginFinished(cache: cache)
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

  private func handleLoginFinished(cache: UserCache?) {
    guard let cache else { return }
    cacheViewModel.setUserCache(cache)
    router.navigateToRoot()
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
}

extension RegularRegisterPage {
  var content: some View {
    VStack(spacing: Constants.spacing) {
      navigationBar
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
    .padding(.horizontal)
  }

  var navigationBar: some View {
    NavigationTitle("Create an account")
  }

  var emailInput: some View {
    TextEditFormItemWithBlockTitle(
      title: "Email",
      hint: "Email",
      text: $registerViewModel.dto.email
    )
  }

  var firstNameInput: some View {
    TextEditFormItemWithBlockTitle(
      title: "First name",
      hint: "First name",
      text: $registerViewModel.dto.firstName
    )
  }

  var lastNameInput: some View {
    TextEditFormItemWithBlockTitle(
      title: "Last name",
      hint: "Last name",
      text: $registerViewModel.dto.lastName
    )
  }

  var usernameInput: some View {
    TextEditFormItemWithBlockTitle(
      title: "@Username",
      hint: "Username",
      text: $registerViewModel.dto.username
    )
  }

  var passwordInput: some View {
    VStack(alignment: .leading) {
      TextEditFormItemWithBlockTitle(
        title: "Password",
        hint: "Password",
        isSecure: true,
        text: $registerViewModel.dto.password
      )
      Text("Minimum 8 characters or numbers.")
        .font(.footnote)
        .foregroundStyle(.secondary)
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
    .font(.footnote)
    .padding()
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
    .font(.footnote)
    .padding(.horizontal)
  }

  var createButton: some View {
    Button {
      registerViewModel.register()
    } label: {
      BackgroundButtonFormItem(title: "Create Account")
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
      .fontWeight(.semibold)
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

private enum Constants {
  static let spacing = 10.0
  static let pickerLineImageSpacing = 10.0
  static let buttonDisabledOpacity = 0.5
}

#Preview {
  RegularRegisterPage(registerViewModel: RegisterViewModel())
}
