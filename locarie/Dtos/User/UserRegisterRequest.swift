//
//  UserRegisterRequest.swift
//  locarie
//
//  Created by qiuty on 28/12/2023.
//

import Foundation

protocol UserLocation: Codable {
  var address: String { get set }
  var neighborhood: String { get set }
  var location: BusinessLocation? { get set }
}

struct RegisterRequestDto: UserLocation {
  var type: UserType = .regular
  var email = ""
  var firstName = ""
  var lastName = ""
  var username = ""
  var password = ""

  var businessName = ""
  var categories: [String] = []
  var address = ""
  var neighborhood = ""
  var location: BusinessLocation?
}
