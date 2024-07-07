//
//  ProfileFavoredByCount.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct ProfileFavoredByCount: View {
  let count: Int

  init(_ count: Int) {
    self.count = count
  }

  var body: some View {
    HStack(spacing: 10) {
      Image("Bookmark")
        .resizable()
        .scaledToFit()
        .frame(size: 16)
      Text("\(count)")
    }
  }
}
