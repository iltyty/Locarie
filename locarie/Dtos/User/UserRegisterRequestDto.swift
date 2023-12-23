//
//  UserRegisterRequestDto.swift
//  locarie
//
//  Created by qiuty on 22/12/2023.
//

import Foundation

struct UserRegisterRequestDto: Codable {
  var email: String = ""
  var firstName: String = ""
  var lastName: String = ""
  var password: String = ""
  var confirmPassword: String = ""
  var businessName: String?
  var businessCategory: String?
  var businessAddress: String?
}
