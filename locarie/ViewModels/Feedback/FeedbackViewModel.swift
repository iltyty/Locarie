//
//  FeedbackViewModel.swift
//  locarie
//
//  Created by qiuty on 26/02/2024.
//

import Combine
import Foundation

final class FeedbackViewModel: BaseViewModel {
  @Published var state: State = .idle

  private let networking: FeedbackService
  private var subscriptions: Set<AnyCancellable> = []

  init(_ networking: FeedbackService = FeedbackServiceImpl.shared) {
    self.networking = networking
  }

  func send(userId: Int64, content: String) {
    if case .loading = state {
      return
    }
    state = .loading
    networking.send(userId: userId, content: content)
      .sink { [weak self] response in
        guard let self else { return }
        handleSendResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func handleSendResponse(_ response: FeedbackSendResponse) {
    if let error = response.error {
      state = .failed(error)
      return
    }
    if response.value!.status != 0 {
      state = .failed(newNetworkError(response: response.value!))
      return
    }
    state = .finished
  }
}

extension FeedbackViewModel {
  enum State {
    case idle
    case loading
    case finished
    case failed(NetworkError)
  }
}
