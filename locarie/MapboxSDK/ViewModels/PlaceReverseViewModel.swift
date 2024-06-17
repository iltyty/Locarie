//
//  PlaceReverseViewModel.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import Combine
import CoreLocation
import Foundation

public final class PlaceReverseViewModel: ObservableObject {
  @Published var address = ""
  @Published var neighborhood = "Neighborhood"
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
        address = feature.properties.context.address?.name ?? ""
        neighborhood = feature.properties.context.neighborhood?.name ?? ""
        if neighborhood.isEmpty {
          neighborhood = feature.properties.context.locality?.name ?? ""
        }
      }
      state = .finished
    }
  }
}

public extension PlaceReverseViewModel {
  enum State {
    case idle
    case loading
    case finished
    case failed(MapboxError)
  }
}
