//
//  BusinessUserRegisterViewModel.swift
//  locarie
//
//  Created by qiuty on 23/12/2023.
//

import Combine
import Foundation

final class BusinessUserRegisterViewModel: ObservableObject {
  @Published var dto = BusinessuserRegisterRequestDto()
  @Published var isFormValid = false

  private var publishers: Set<AnyCancellable> = []

  init() {
    isFormValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.isFormValid, on: self)
      .store(in: &publishers)
  }
}

private extension BusinessUserRegisterViewModel {
  var isBusinessNameValidPublisher: AnyPublisher<Bool, Never> {
    $dto.map { dto in
      !dto.businessName.isEmpty
    }
    .eraseToAnyPublisher()
  }

  var isBusinessCategoryValidPublisher: AnyPublisher<Bool, Never> {
    $dto.map { dto in
      !dto.category.isEmpty
    }
    .eraseToAnyPublisher()
  }

  var isBusinessAddressValidPublisher: AnyPublisher<Bool, Never> {
    $dto.map { dto in
      !dto.address.isEmpty
    }
    .eraseToAnyPublisher()
  }

  var isFormValidPublisher: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest3(
      isBusinessNameValidPublisher,
      isBusinessCategoryValidPublisher,
      isBusinessAddressValidPublisher
    )
    .map { $0 && $1 && $2 }
    .eraseToAnyPublisher()
  }
}
