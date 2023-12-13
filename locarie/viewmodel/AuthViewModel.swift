//
//  AuthViewModel.swift
//  locarie
//
//  Created by qiuty on 12/12/2023.
//

import SwiftUI
import Foundation


class AuthViewModel: ObservableObject {
    func login(
        email: String,
        password: String,
        onSuccess: @escaping Completion,
        onFailure: @escaping Completion,
        onError: @escaping (Error) -> Void
    ) {
        Task {
            do {
                let dto = UserLoginRequestDto(email: email, password: password)
                let response = try await APIServices.login(dto: dto)
                handleLoginResponse(response, onSuccess: onSuccess, onFailure: onFailure)
            } catch {
                handleLoginError(error, completion: onError)
            }
        }
    }
    
    private func handleLoginResponse(
        _ response: Response,
        onSuccess: Completion,
        onFailure: Completion
    ) {
        response.status == 0
            ? handleLoginSuccess(response, completion: onSuccess)
            : handleLoginFailure(response, completion: onFailure)
    }
    
    private func handleLoginError(_ error: Error, completion: (Error) -> Void) {
        completion(error)
    }
    
    private func handleLoginSuccess(_ response: Response, completion: Completion) {
        completion(response)
    }
    
    private func handleLoginFailure(_ response: Response,completion: Completion) {
        completion(response)
    }
}


extension AuthViewModel {
    typealias Response = ResponseDto<UserLoginResponse>
    typealias Completion = (_ response: Response) -> Void
}
