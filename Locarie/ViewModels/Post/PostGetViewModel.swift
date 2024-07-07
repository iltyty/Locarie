//
//  PostGetViewModel.swift
//  locarie
//
//  Created by qiuty on 17/04/2024.
//

import Combine
import Foundation

final class PostGetViewModel: BaseViewModel {
  @Published var state: State = .idle
  @Published var favoredByCount: Int = 0

  private let networking: PostGetService
  private var subscriptions: Set<AnyCancellable> = []

  init(_ networking: PostGetService = PostGetServiceImpl.shared) {
    self.networking = networking
  }

  func getFavoredByCount(id: Int64) {
    networking.getFavoredByCount(id: id)
      .sink { [weak self] response in
        guard let self else { return }
        if let error = response.error {
          state = .failed(error)
          return
        }
        let dto = response.value!
        if dto.status != 0 {
          state = .failed(newNetworkError(response: dto))
          return
        }
        if let count = dto.data {
          favoredByCount = count
        }
        state = .finished
      }
      .store(in: &subscriptions)
  }
}

extension PostGetViewModel {
  enum State {
    case idle
    case loading
    case finished
    case failed(NetworkError)
  }
}
