//
//  CustomInputField.swift
//  locarie
//
//  Created by qiuty on 05/12/2023.
//

import SwiftUI

struct CustomInputField: View {
    let hint: String
    let value: Binding<String>
    let isPassword: Bool
        
    var body: some View {
        Group {
            if isPassword {
                SecureField(hint, text: value)
            } else {
                TextField(hint, text: value)
            }
        }
        .padding(.vertical, Constants.verticalPadding)
        .padding(.horizontal, Constants.horizontalPadding)
        .background(Color.white.opacity(Constants.bgOpacity))
        .clipShape(.rect(cornerRadius: Constants.cornerRadius, style: .continuous))
    }
}

fileprivate struct Constants {
    static let verticalPadding = 10.0
    static let horizontalPadding = 15.0
    static let bgOpacity = 0.12
    static let cornerRadius = 10.0
}

#Preview {
    @State var email = ""
    return CustomInputField(hint: "email", value: $email, isPassword: false)
}
