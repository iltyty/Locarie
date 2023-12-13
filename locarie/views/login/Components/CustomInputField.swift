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
        .textInputAutocapitalization(.never)
        .padding(.vertical, CustomInputFieldConstants.verticalPadding)
        .padding(.horizontal, CustomInputFieldConstants.horizontalPadding)
        .background(Color.white.opacity(CustomInputFieldConstants.bgOpacity))
        .clipShape(.rect(cornerRadius: CustomInputFieldConstants.cornerRadius, style: .continuous))
    }
}

struct CustomInputFieldConstants {
    static let verticalPadding = 10.0
    static let horizontalPadding = 15.0
    static let bgOpacity = 0.12
    static let cornerRadius = 10.0
}

#Preview {
    @State var email = ""
    return CustomInputField(hint: "email", value: $email, isPassword: false)
}
