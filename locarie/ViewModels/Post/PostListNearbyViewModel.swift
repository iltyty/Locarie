//
//  PostListNearbyViewModel.swift
//  locarie
//
//  Created by qiuty on 21/12/2023.
//

import CoreLocation
import Foundation

final class PostListNearbyViewModel: ObservableObject {
  @Published var posts = [PostDto]()

  func getNearbyPosts(
    withLocation location: CLLocation,
    onError: (Error) -> Void
  ) async {
    do {
      let response = try await APIServices.listNearbyPosts(
        latitude: location.coordinate.latitude,
        longitude: location.coordinate.longitude,
        distance: GlobalConstants.postsNearbyDistance
      )
      handleListResponse(response)
    } catch {
      onError(error)
    }
  }

  private func handleListResponse(_ response: Response) {
    response.status == 0
      ? handleListSuccess(response)
      : handleListFailure(response)
  }

  private func handleListSuccess(_ response: Response) {
    if let posts = response.data {
      self.posts = posts
    }
  }

  private func handleListFailure(_ response: Response) {
    print(response.message)
  }
}

private typealias Response = ResponseDto<[PostDto]>
