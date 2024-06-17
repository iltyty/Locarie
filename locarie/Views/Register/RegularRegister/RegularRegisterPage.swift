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

  @FocusState private var focusField: Field?

  var body: some View {
    GeometryReader { _ in
      VStack(spacing: 32) {
        NavigationBar("Create an account")
        ScrollView {
          VStack(spacing: 16) {
            emailInput
            firstNameInput
            lastNameInput
            usernameInput
            passwordInput
            bottomText
            createButton
            Spacer()
          }
          .padding(.horizontal, 16)
        }
      }
    }
    .ignoresSafeArea(.keyboard)
    .disabled(isLoading)
    .keyboardDismissable(focus: $focusField)
    .overlay { isLoading ? ProgressView() : nil }
    .alert(alertTitle, isPresented: $isAlertShowing) {}
    .onReceive(registerViewModel.$state) { state in
      handleRegisterStateChange(state)
    }
    .onReceive(loginViewModel.$state) { state in
      handleLoginStateChange(state)
    }
  }
}

private extension RegularRegisterPage {
  var emailInput: some View {
    TextEditFormItemWithBlockTitle(
      title: "Email",
      hint: "Email",
      text: $registerViewModel.dto.email
    )
    .focused($focusField, equals: .email)
    .textContentType(.emailAddress)
  }

  var firstNameInput: some View {
    TextEditFormItemWithBlockTitle(
      title: "First name",
      hint: "First name",
      text: $registerViewModel.dto.firstName
    )
    .focused($focusField, equals: .firstName)
    .textContentType(.givenName)
  }

  var lastNameInput: some View {
    TextEditFormItemWithBlockTitle(
      title: "Last name",
      hint: "Last name",
      text: $registerViewModel.dto.lastName
    )
    .focused($focusField, equals: .lastName)
    .textContentType(.familyName)
  }

  var usernameInput: some View {
    TextEditFormItemWithBlockTitle(
      title: "@Username",
      hint: "Username",
      text: $registerViewModel.dto.username
    )
    .focused($focusField, equals: .username)
    .textContentType(.username)
  }

  var passwordInput: some View {
    VStack(alignment: .leading, spacing: 10) {
      TextEditFormItemWithBlockTitle(
        title: "Password",
        hint: "Password",
        isSecure: true,
        text: $registerViewModel.dto.password
      )
      .focused($focusField, equals: .password)
      .textContentType(.password)
      Text("Minimum 8 characters or numbers.")
        .font(.custom(GlobalConstants.fontName, size: 14))
        .foregroundStyle(LocarieColor.greyDark)
        .padding(.leading, 16)
    }
  }

  var bottomText: some View {
    VStack(alignment: .leading, spacing: 20) {
      notificationPicker
      servicePicker
      noteText
    }
    .font(.custom(GlobalConstants.fontName, size: 14))
    .padding(.leading, 16)
  }

  var notificationPicker: some View {
    let systemName = isNotificationReceived ? "circle.fill" : "circle"
    return HStack(alignment: .top, spacing: 10) {
      pickerLineImage(systemName: systemName, isFilled: $isNotificationReceived)
      Text("I do not wish to receive notifications with updates and news.")
      Spacer()
    }
  }

  var servicePicker: some View {
    let systemName = isServiceAgreed ? "circle.fill" : "circle"
    return HStack(alignment: .top, spacing: 10) {
      pickerLineImage(systemName: systemName, isFilled: $isServiceAgreed)
      Text("""
      I agree to the \(Text("Privacy Policy").foregroundColor(LocarieColor.primary)), \
      \(Text("Terms of use").foregroundColor(LocarieColor.primary)), \
      \(Text("Community Guidelines").foregroundColor(LocarieColor.primary)), and \
      \(Text("Terms of Service").foregroundColor(LocarieColor.primary)).
      """)
      Spacer()
    }
  }

  var noteText: some View {
    Text(
      "Note: If the user shares false information or any action violates our safety regulations, necessary actions will be taken."
    )
    .foregroundStyle(LocarieColor.greyDark)
    .padding(.leading, 28)
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
      .frame(width: 18, height: 18)
      .foregroundStyle(Color.locariePrimary)
      .contentShape(Rectangle())
      .onTapGesture {
        isFilled.wrappedValue.toggle()
      }
  }
}

private extension RegularRegisterPage {
  func handleRegisterStateChange(_ state: RegisterViewModel.State) {
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

  func handleLoginStateChange(_ state: LoginViewModel.State) {
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

  func handleRegisterFinished() {
    loginViewModel.setDto(from: registerViewModel.dto)
    loginViewModel.login()
  }

  func handleLoginFinished(cache: UserCache?) {
    guard let cache else { return }
    cacheViewModel.setUserCache(cache)
    router.navigateToRoot()
  }

  func handleNetworkError(_ error: NetworkError) {
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

private enum Field {
  case email, firstName, lastName, username, password
}

private enum Constants {
  static let buttonDisabledOpacity = 0.5
}

#Preview {
  RegularRegisterPage(registerViewModel: RegisterViewModel())
}
