//
//  RegisterPage.swift
//  locarie
//
//  Created by qiuty on 05/12/2023.
//

import SwiftUI

struct RegisterPage: View {
    @EnvironmentObject var cacheViewModel: LocalCacheViewModel

    @StateObject private var user = User()

    @State private var isLoading = false
    @State private var isAlertShowing = false
    @State private var alertTitle: AlertTitle?

    private let authViewModel = AuthViewModel()

    var body: some View {
        makeLoginPageBackground(content)
            .disabled(isLoading)
            .overlay { overlayView }
            .alert(
                alertTitle?.rawValue ?? "",
                isPresented: $isAlertShowing
            ) { Button("OK") {} }
    }

    var overlayView: some View {
        isLoading ? loadingView : nil
    }

    var loadingView: some View {
        ProgressView().progressViewStyle(.circular)
    }

    private var content: some View {
        VStack(spacing: LoginRegisterPageConstants.tableItemSpace) {
            title
            userTypeChooser
            if user.type == .plain {
                plainForm
            } else {
                businessForm
            }
            btnRegister
        }
    }

    private var title: some View {
        makeLoginPageTitle("Register")
    }

    private var userTypeChooser: some View {
        Picker("UserType", selection: $user.type) {
            ForEach(User.UserType.allCases) { type in
                Text(type.rawValue)
            }
        }
        .pickerStyle(.segmented)
    }

    private var plainForm: some View {
        VStack(alignment: .leading, spacing: LoginRegisterPageConstants.tableInputSpace) {
            makeLoginPageFieldInput(text: "Username", hint: "username", input: $user.username, isPassword: false)
            makeLoginPageFieldInput(text: "Email", hint: "email", input: $user.email, isPassword: false)
            makeLoginPageFieldInput(text: "Password", hint: "password", input: $user.password, isPassword: true)
        }
    }

    private var businessForm: some View {
        VStack(spacing: LoginRegisterPageConstants.tableItemSpace) {
            plainForm
            makeLoginPageFieldInput(text: "Homepage", hint: "homepage url", input: $user.homepageUrl, isPassword: false)
            makeLoginPageFieldInput(text: "Phone", hint: "phone number", input: $user.phone, isPassword: false)
            introductionInput
        }
    }

    private var introductionInput: some View {
        VStack(alignment: .leading) {
            Text("Introduction")
                .font(.callout.bold())
            TextEditor(text: $user.introduction)
                .scrollContentBackground(.hidden)
                .padding(.horizontal)
                .background(Color.white.opacity(CustomInputFieldConstants.bgOpacity))
                .clipShape(.rect(cornerRadius: CustomInputFieldConstants.cornerRadius))
        }
    }

    private var btnRegister: some View {
        loginPageButtonBuilder("Register") {
            register()
        }
    }
}

extension RegisterPage {
    private func register() {
        isLoading = true
        Task {
            do {
                let response = try await APIServices.register(user: user)
                handleRegisterResponse(response)
            } catch {
                handleRegisterError(error)
            }
        }
    }

    private func handleRegisterResponse(_ response: ResponseDto<User>) {
        response.status == 0
            ? handleRegisterSuccess(response)
            : handleRegisterFailure(response)
    }

    private func handleRegisterError(_: Error) {
        isLoading = false
        alertTitle = .unknownError
        isAlertShowing = true
    }

    private func handleRegisterSuccess(_: ResponseDto<User>) {
        login()
    }

    private func handleRegisterFailure(_ response: ResponseDto<User>) {
        isLoading = false
        if let code = ResultCode(rawValue: response.status) {
            switch code {
            case .emailAlreadyInUse:
                alertTitle = .emailAlreadyInUse
            default:
                alertTitle = .unknownError
            }
        } else {
            alertTitle = .unknownError
        }
        isAlertShowing = true
    }
}

extension RegisterPage {
    private func login() {
        authViewModel.login(
            email: user.email,
            password: user.password,
            onSuccess: handleLoginSuccess,
            onFailure: handleLoginFailure,
            onError: handleLoginError
        )
    }

    private func handleLoginError(_: Error) {
        isLoading = false
        alertTitle = .unknownError
        isAlertShowing = true
    }

    private func handleLoginSuccess(_ response: Response) {
        isLoading = false
        alertTitle = .success
        if let info = response.data {
            cacheViewModel.setUserInfo(info)
        }
        isAlertShowing = true
    }

    private func handleLoginFailure(_ response: Response) {
        isLoading = false
        if let code = ResultCode(rawValue: response.status) {
            switch code {
            case .incorrectCredentials:
                alertTitle = .incorrectCredential
            default:
                alertTitle = .unknownError
            }
        } else {
            alertTitle = .unknownError
        }
        isAlertShowing = true
    }
}

extension RegisterPage {
    private enum AlertTitle: String {
        case success = "Register success"
        case incorrectCredential = "Incorret email or password"
        case emailAlreadyInUse = "Email already in use"
        case unknownError = "Something went wrong, please try again later"
    }
}

extension RegisterPage {
    private typealias Response = ResponseDto<UserLoginResponse>
    private typealias Completion = (_ response: Response) -> Void
}

#Preview {
    RegisterPage()
        .environmentObject(LocalCacheViewModel())
}
