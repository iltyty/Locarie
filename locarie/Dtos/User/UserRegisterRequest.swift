//
//  UserRegisterRequest.swift
//  locarie
//
//  Created by qiuty on 28/12/2023.
//

import Foundation

struct RegisterRequestDto: Codable {
  var type: UserType = .regular
  var email = ""
  var firstName = ""
  var lastName = ""
  var username = ""
  var password = ""

  var businessName = ""
  var categories: [String] = []
  var address = ""
  var location: BusinessLocation?
}
