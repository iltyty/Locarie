//
//  LoginPageUtil.swift
//  locarie
//
//  Created by qiuty on 05/12/2023.
//

import SwiftUI
import Foundation

func makeLoginPageBackground<T: View>(_ content: T) -> some View {
    content
        .padding(.horizontal, Constants.tableHorizontalPadding)
        .padding(.vertical, Constants.tableVerticalPadding)
        .background(
            Color
                .white
                .opacity(Constants.tableBgOpacity)
                .clipShape(.rect(cornerRadius: Constants.tableBgCornerRadius))
        )
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("LoginBackground")
                .resizable()
                .scaledToFill()
                .blur(radius: Constants.bgBlurRadius)
                .ignoresSafeArea(edges: .all)
        )
}

func makeLoginPageTitle(_ title: String) -> some View {
    Text(title)
        .font(.title)
        .fontWeight(.semibold)
}

func makeLoginPageFieldInput(text: String, hint: String, input: Binding<String>, isPassword: Bool) -> some View {
    VStack(alignment: .leading) {
        Text(text)
            .font(.callout.bold())
        CustomInputField(hint: hint, value: input, isPassword: isPassword)
    }
}

func loginPageButtonLabel(_ title: String) -> some View {
    Text(title)
        .fontWeight(.semibold)
        .foregroundStyle(.black)
        .padding(.vertical, Constants.btnTitlePaddingVertical)
        .frame(maxWidth: .infinity)
        .background(.background)
        .clipShape(.rect(cornerRadius: Constants.btnCornerRadius))
}

func loginPageButtonBuilder(_ title: String, action: @escaping () -> Void) -> some View {
    Button {
        action()
    } label: {
        loginPageButtonLabel(title)
    }
}

struct LoginRegisterPageConstants {
    static let tableItemSpace = 10.0
    static let tableInputSpace = 8.0
    static let btnPaddingTop = 20.0
}

fileprivate struct Constants {
    // background image constants
    static let bgBlurRadius = 8.0
    
    // form table constants
    static let tableVerticalPadding = 30.0
    static let tableHorizontalPadding = 15.0
    static let tableBgCornerRadius = 20.0
    static let tableBgOpacity = 0.5
    
    // button constants
    static let btnTitlePaddingVertical = 12.0
    static let btnCornerRadius = 10.0
}
