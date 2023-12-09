//
//  LoginPage.swift
//  locarie
//
//  Created by qiuty on 05/12/2023.
//

import SwiftUI

struct LoginPage: View {
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        NavigationView {
            makeLoginPageBackground(formTable)
        }
    }
    
    var formTable: some View {
        VStack(spacing: LoginPageConstants.tableItemSpace) {
            makeLoginPageTitle("Login")
            VStack(alignment: .leading, spacing: LoginPageConstants.tableInputSpace) {
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
        loginPageButtonBuilder("Login") {
            print("login button clicked")
        }
        .padding(.top, LoginPageConstants.btnPaddingTop)
    }
}

#Preview {
    LoginPage()
}
