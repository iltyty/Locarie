//
//  NetworkConfig.swift
//  locarie
//
//  Created by qiuty on 09/12/2023.
//

import Foundation

class NetworkConfig {
    static let shared = NetworkConfig()
    let urlConfig: URLSessionConfiguration
    let urlSession: URLSession
    
    private init() {
        urlConfig = URLSessionConfiguration.default
        urlConfig.waitsForConnectivity = true
        urlSession = URLSession(configuration: urlConfig)
    }
}
