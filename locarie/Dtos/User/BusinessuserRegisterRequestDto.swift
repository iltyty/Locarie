//
//  BusinessuserRegisterRequestDto.swift
//  locarie
//
//  Created by qiuty on 23/12/2023.
//

import CoreLocation
import Foundation

struct BusinessuserRegisterRequestDto: Codable {
  var email = ""
  var firstName = ""
  var lastName = ""
  var username = ""
  var password = ""

  var businessName = ""
  var category = ""
  var address = ""
  var location: BusinessLocation?
}

struct BusinessLocation: Codable {
  var latitude = 0.0
  var longitude = 0.0
}
