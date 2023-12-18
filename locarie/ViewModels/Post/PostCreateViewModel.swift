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
        let user = UserId(id: LocalCache.shared.userId)
        post = PostCreateRequestDto(user: user, title: "", content: "")
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isFormValid, on: self)
            .store(in: &publishers)
    }

    func reset() {
        post.title = ""
        post.content = ""
    }
}

private extension PostCreateViewModel {
    var isTitleValidPublisher: AnyPublisher<Bool, Never> {
        $post
            .map { post in
                !post.title.isEmpty
            }
            .eraseToAnyPublisher()
    }

    var isContentValidPublisher: AnyPublisher<Bool, Never> {
        $post
            .map { post in
                !post.title.isEmpty
            }
            .eraseToAnyPublisher()
    }

    var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(
            isTitleValidPublisher,
            isContentValidPublisher
        )
        .map { isTitleValid, isContentValid in
            isTitleValid && isContentValid
        }
        .eraseToAnyPublisher()
    }
}
