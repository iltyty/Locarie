//
//  PostDeleteViewModel.swift
//  locarie
//
//  Created by qiuty on 19/06/2024.
//

import Combine
import Foundation

final class PostDeleteViewModel: BaseViewModel {
  @Published var state: State = .idle

  private let networking: PostDeleteService
  private var subscriptions: Set<AnyCancellable> = []

  init(_ networking: PostDeleteService = PostDeleteServiceImpl.shared) {
    self.networking = networking
  }

  func delete(id: Int64) {
    state = .loading
    networking.delete(id: id)
      .sink { [weak self] response in
        guard let self else { return }
        handleResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func handleResponse(_ response: PostDeleteResponse) {
    if let error = response.error {
      state = .failed(error)
      return
    }
    let dto = response.value!
    if dto.status != 0 {
      state = .failed(newNetworkError(response: dto))
      return
    }
    state = .finished
  }
}

extension PostDeleteViewModel {
  enum State {
    case idle, loading, finished, failed(NetworkError)
  }
}
