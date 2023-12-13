//
//  LoginPage.swift
//  locarie
//
//  Created by qiuty on 05/12/2023.
//

import SwiftUI

struct LoginPage: View {
    @EnvironmentObject var cacheViewModel: LocalCacheViewModel

    @State private var email: String = ""
    @State private var password: String = ""

    @State private var isLoading = false
    @State private var isAlertShowing = false
    @State private var alertTitle: AlertTitle?

    private let authViewModel = AuthViewModel()

    var body: some View {
        NavigationView {
            makeLoginPageBackground(formTable)
                .disabled(isLoading)
                .overlay { overlayView }
                .alert(alertTitle?.rawValue ?? "", isPresented: $isAlertShowing) {
                    Button("OK") {}
                }
        }
    }

    var overlayView: some View {
        isLoading ? loadingView.background(Color.white.opacity(0.05)) : nil
    }

    var loadingView: some View {
        ProgressView().progressViewStyle(.circular)
    }

    var formTable: some View {
        VStack(spacing: LoginRegisterPageConstants.tableItemSpace) {
            makeLoginPageTitle("Login")
            VStack(alignment: .leading, spacing: LoginRegisterPageConstants.tableInputSpace) {
                makeLoginPageFieldInput(text: "Email", hint: "email", input: $email, isPassword: false)
                makeLoginPageFieldInput(text: "Password", hint: "password", input: $password, isPassword: true)
                btnLogin
                NavigationLink {
                    RegisterPage()
                } label: {
                    loginPageButtonLabel("Register")
                }
            }
        }
    }

    var btnLogin: some View {
        loginPageButtonBuilder("Login") { login() }
            .padding(.top, LoginRegisterPageConstants.btnPaddingTop)
    }
}

extension LoginPage {
    private func login() {
        isLoading = true
        authViewModel.login(
            email: email,
            password: password,
            onSuccess: handleLoginSuccess,
            onFailure: handleLoginFailure,
            onError: handleLoginError
        )
    }

    private func handleLoginSuccess(_ response: Response) {
        isLoading = false
        if let info = response.data {
            cacheViewModel.setUserInfo(info)
        }
        alertTitle = .success
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

    private func handleLoginError(_: Error) {
        isLoading = false
        alertTitle = .unknownError
        isAlertShowing = true
    }
}

extension LoginPage {
    private enum AlertTitle: String {
        case success = "Login success"
        case incorrectCredential = "Incorret email or password"
        case unknownError = "Something went wrong, please try again later"
    }
}

extension LoginPage {
    private typealias Response = ResponseDto<UserLoginResponse>
    private typealias Completion = (_ response: Response) -> Void
}

#Preview {
    LoginPage()
        .environmentObject(LocalCacheViewModel())
}
