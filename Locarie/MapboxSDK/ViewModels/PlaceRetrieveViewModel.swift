//
//  PlaceRetrieveViewModel.swift
//  locarie
//
//  Created by qiuty on 27/12/2023.
//

import Alamofire
import Combine
import Foundation

public final class PlaceRetrieveViewModel: ObservableObject {
  @Published var state: State = .idle

  private let networking: MapboxRetrieveService
  private var subscriptions: Set<AnyCancellable> = []

  init(_ networking: MapboxRetrieveService = MapboxRetrieveServiceImpl.shared) {
    self.networking = networking
  }

  func retrieve(mapboxId: String) {
    networking.retrievePlace(forId: mapboxId)
      .sink { [weak self] completion in
        guard let self else { return }
        handleSinkCompletion(completion)
      } receiveValue: { [weak self] value in
        guard let self else { return }
        handleSinkValue(value)
      }
      .store(in: &subscriptions)
  }

  private func handleSinkCompletion(
    _ completion: Subscribers.Completion<AFError>
  ) {
    switch completion {
    case let .failure(error):
      debugPrint(error)
      state = error.isSessionTaskError ?
        .failed(.noInternet) : .failed(.unknown(error))
    case .finished:
      break
    }
  }

  private func handleSinkValue(_ value: PlaceRetrieveResponseDto) {
    state = .loaded(value.features.first)
  }
}

public extension PlaceRetrieveViewModel {
  enum State {
    case idle
    case loaded(PlaceRetrieveDto?)
    case failed(MapboxError)
  }
}
