//
//  UserInfo.swift
//  locarie
//
//  Created by qiuty on 12/12/2023.
//

protocol UserInfo {
    var id: Double { get }
    var username: String { get }
    var jwtToken: String { get }
}
