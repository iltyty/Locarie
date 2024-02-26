//
//  AuthEndpoints.swift
//  locarie
//
//  Created by qiuty on 26/02/2024.
//

import Foundation

extension APIEndpoints {
  static let authUrl = baseUrl + "/auth"
  static let forgotPasswordUrl = authUrl + "/forgot-password"
  static let validateForgotPasswordUrl = forgotPasswordUrl + "/validate"
  static let resetPasswordUrl = authUrl + "/reset-password"
}
