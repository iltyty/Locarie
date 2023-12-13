//
//  APIServices.swift
//  locarie
//
//  Created by qiuty on 09/12/2023.
//

import Alamofire
import Foundation
import SwiftUI

class APIServices {
    static func handleError(_ error: Error) throws {
        if let afError = error.asAFError, let error = afError.underlyingError {
            throw error
        }
        throw error
    }
}
