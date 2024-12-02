//
//  RegularRegisterPage.swift
//  locarie
//
//  Created by qiuty on 22/12/2023.
//

import SwiftUI

struct RegularRegisterPage: View {
  var isBusinessUser = false

  @StateObject var cacheViewModel = LocalCacheViewModel.shared
  @StateObject var registerViewModel = RegisterViewModel()
  @StateObject var loginViewModel = LoginViewModel()
  
  @ObservedObject private var router = Router.shared

  @State private var isNotificationReceived = false
  @State private var isServiceAgreed = false

  @State private var isLoading = false
  @State private var alertTitle = ""
  @State private var isAlertShowing = false

  @FocusState private var focusField: Field?

  var body: some View {
    GeometryReader { _ in
      VStack(spacing: 0) {
        NavigationBar("Create an account").padding(.bottom, 16)
        ScrollView {
          VStack(spacing: 16) {
            VStack(spacing: 16) {
              emailInput
              firstNameInput
              lastNameInput
              if !isBusinessUser {
                usernameInput
              }
              passwordInput
            }
            .keyboardDismissable(focus: $focusField)

            bottomText
            createButton
            Spacer()
          }
          .padding(.top, 16)
          .padding(.horizontal, 16)
        }
        .keyboardAdaptive()
      }
    }
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
}

private extension RegularRegisterPage {
  var emailInput: some View {
    TextEditFormItemWithBlockTitleAndStatus(
      title: "Email",
      hint: "Email",
      valid: registerViewModel.isEmailValid,
      text: $registerViewModel.dto.email
    )
    .focused($focusField, equals: .email)
    .textContentType(.emailAddress)
  }

  var firstNameInput: some View {
    TextEditFormItemWithBlockTitleAndStatus(
      title: "First name",
      hint: "First name",
      note: "Maximum 25 letters.",
      valid: registerViewModel.isFirstNameValid,
      text: $registerViewModel.dto.firstName
    )
    .focused($focusField, equals: .firstName)
    .textContentType(.givenName)
  }

  var lastNameInput: some View {
    TextEditFormItemWithBlockTitleAndStatus(
      title: "Last name",
      hint: "Last name",
      note: "Maximum 25 letters.",
      valid: registerViewModel.isLastNameValid,
      text: $registerViewModel.dto.lastName
    )
    .focused($focusField, equals: .lastName)
    .textContentType(.familyName)
  }

  var usernameInput: some View {
    TextEditFormItemWithBlockTitleAndStatus(
      title: "@Username",
      hint: "Username",
      note: "Only letters, numbers, and certain symbols are allowed.",
      valid: registerViewModel.isUsernameValid,
      text: $registerViewModel.dto.username
    )
    .focused($focusField, equals: .username)
    .textContentType(.username)
  }

  var passwordInput: some View {
    VStack(alignment: .leading, spacing: 10) {
      TextEditFormItemWithBlockTitleAndStatus(
        title: "Password",
        hint: "Password",
        note: "Minimum 8 characters or numbers.",
        valid: registerViewModel.isPasswordValid,
        isSecure: true,
        text: $registerViewModel.dto.password
      )
      .focused($focusField, equals: .password)
      .textContentType(.password)
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
      WrappingHStack(hSpacing: 0) {
        Text("I agree to the ")
        NavigationLink(value: Router.Destination.privacyPolicy) {
          Text("Privacy Policy").foregroundStyle(LocarieColor.primary)
        }
        .buttonStyle(.plain)
        Text(", ")
        NavigationLink(value: Router.Destination.communityGuidelines) {
          Text("Community ").foregroundColor(LocarieColor.primary)
        }
        .buttonStyle(.plain)
        NavigationLink(value: Router.Destination.communityGuidelines) {
          Text("Guide").foregroundColor(LocarieColor.primary)
        }
        .buttonStyle(.plain)
        Text(" and, ")
        NavigationLink(value: Router.Destination.termsOfService) {
          Text("Terms of Service").foregroundColor(LocarieColor.primary)
        }
        .buttonStyle(.plain)
        Text(".")
      }
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
      .frame(size: 18)
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
