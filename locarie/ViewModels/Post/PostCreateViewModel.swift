//
//  PostCreateViewModel.swift
//  locarie
//
//  Created by qiuty on 18/12/2023.
//

import Combine
import Foundation

final class PostCreateViewModel: ObservableObject {
  @Published var post: PostCreateRequestDto

  @Published var isFormValid = false

  private var publishers: Set<AnyCancellable> = []

  init() {
    let user = UserId(id: Int64(LocalCache.shared.userId))
    post = PostCreateRequestDto(user: user, content: "")
    isFormValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.isFormValid, on: self)
      .store(in: &publishers)
  }

  func reset() {
    post.content = ""
  }
}

private extension PostCreateViewModel {
  var isFormValidPublisher: AnyPublisher<Bool, Never> {
    $post
      .map { post in
        !post.content.isEmpty
      }
      .eraseToAnyPublisher()
  }
}
