//
//  UserInfo.swift
//  locarie
//
//  Created by qiuty on 12/12/2023.
//

protocol UserInfo {
  var id: Int64 { get }
  var email: String { get }
  var type: UserType { get }
  var username: String { get }
  var avatarUrl: String { get }
}

protocol UserToken {
  var jwtToken: String { get }
}

protocol UserCache: UserInfo, UserToken {}
