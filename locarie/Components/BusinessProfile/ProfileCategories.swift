//
//  ProfileCategories.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct ProfileCategories: View {
  let user: UserDto

  init(_ user: UserDto) {
    self.user = user
  }

  var body: some View {
    if #available(iOS 16.4, *) {
      scrollView.scrollBounceBehavior(.basedOnSize)
    } else {
      scrollView
    }
  }

  private var scrollView: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(user.categories, id: \.self) { category in
          ProfileBusinessCategoryView(category)
        }
      }
    }
    .scrollIndicators(.hidden)
  }
}
