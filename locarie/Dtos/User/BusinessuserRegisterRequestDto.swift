//
//  BusinessuserRegisterRequestDto.swift
//  locarie
//
//  Created by qiuty on 23/12/2023.
//

import Foundation

struct BusinessuserRegisterRequestDto: Codable {
  var email = ""
  var firstName = ""
  var lastName = ""
  var password = ""
  var confirmPassword = ""
  var businessName = ""
  var businessCategory = ""
  var businessAddress = ""
}
