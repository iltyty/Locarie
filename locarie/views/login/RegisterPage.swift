//
//  RegisterPage.swift
//  locarie
//
//  Created by qiuty on 05/12/2023.
//

import SwiftUI

struct RegisterPage: View {
    @State var userType: UserType = .Plain
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var homepage: String = ""
    @State var phone: String = ""
    @State var introduction: String = ""
    
    var body: some View {
        makeLoginPageBackground(content)
    }
    
    var content: some View {
        VStack(spacing: LoginPageConstants.tableItemSpace) {
            title
            userTypeChooser
            if userType == .Plain {
                plainForm
            } else {
                businessForm
            }
        }
    }
    
    var title: some View {
        makeLoginPageTitle("Register")
    }
    
    var userTypeChooser: some View {
        Picker("UserType", selection: $userType) {
            ForEach(UserType.allCases) { type in
                Text(type.rawValue)
            }
        }
        .pickerStyle(.segmented)
    }
    
    var plainForm: some View {
        VStack(alignment: .leading, spacing: LoginPageConstants.tableInputSpace) {
            makeLoginPageFieldInput(text: "Username", hint: "username", input: $username, isPassword: false)
            makeLoginPageFieldInput(text: "Email", hint: "email", input: $email, isPassword: false)
            makeLoginPageFieldInput(text: "Password", hint: "password", input: $password, isPassword: true)
        }
    }
    
    var businessForm: some View {
        VStack(spacing: LoginPageConstants.tableItemSpace) {
            plainForm
            makeLoginPageFieldInput(text: "Homepage", hint: "homepage url", input: $homepage, isPassword: false)
            makeLoginPageFieldInput(text: "Phone", hint: "phone number", input: $phone, isPassword: false)
            introductionInput
            btnRegister
        }
    }
    
    var introductionInput: some View {
        VStack(alignment: .leading) {
            Text("Introduction")
                .font(.callout.bold())
            TextEditor(text: $introduction)
                .scrollContentBackground(.hidden)
                .padding(.horizontal)
                .background(Color.white.opacity(0.12))
                .clipShape(.rect(cornerRadius: 20.0))
        }
    }
    
    var btnRegister: some View {
        loginPageButtonBuilder("Register") {
            print("register button clicked")
        }
    }
}

extension RegisterPage {
    enum UserType: String, CaseIterable, Identifiable {
        case Plain = "PLAIN"
        case Business = "BUSINESS"
        var id: Self { self }
    }
}

#Preview {
    RegisterPage()
}
