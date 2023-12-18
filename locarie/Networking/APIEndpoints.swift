//
//  APIEndpoints.swift
//  locarie
//
//  Created by qiuty on 09/12/2023.
//

import Foundation

enum APIEndpoints {
    static let baseUrl = "http://localhost:8080/api/v1"
    static let userUrl = baseUrl + "/users"
    static let postUrl = baseUrl + "/posts"

    static let userLoginUrl = URL(string: userUrl + "/login")!
    static let userRegisterUrl = URL(string: userUrl + "/register")!

    static let postCreateUrl = URL(string: postUrl)!
}
