//
//  NeighborhoodLookupViewModel.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import Combine
import CoreLocation
import Foundation

public final class NeighborhoodLookupViewModel: ObservableObject {
  @Published var neighborhood = ""
  @Published var state: State = .idle

  private let networking: MapboxNeighborhoodLookupService
  private var subscriptions: Set<AnyCancellable> = []

  init(_ networking: MapboxNeighborhoodLookupService =
    MapboxNeighborhoodLookupServiceImpl.shared)
  {
    self.networking = networking
  }

  func lookup(forLocation location: CLLocationCoordinate2D) {
    state = .loading
    networking.lookup(forLocation: location)
      .sink { [weak self] response in
        guard let self else { return }
        handleLookupResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func handleLookupResponse(_ response: PlaceReverseLookupResponse) {
    debugPrint(response)
    if let error = response.error {
      state = error
        .isSessionTaskError ? .failed(.noInternet) : .failed(.unknown(error))
    } else {
      let dto = response.value!
      if let feature = dto.features.first {
        neighborhood = feature.properties.context.neighborhood.name
      }
      state = .finished
    }
  }
}

public extension NeighborhoodLookupViewModel {
  enum State {
    case idle
    case loading
    case finished
    case failed(MapboxError)
  }
}
