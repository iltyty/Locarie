//
//  RegularUserProfilePage+SkeletonPage.swift
//  locarie
//
//  Created by qiuty on 12/04/2024.
//

import SwiftUI

extension RegularUserProfilePage {
  var skeleton: some View {
    VStack(alignment: .leading) {
      HStack {
        SkeletonView(72, 72, true)
        VStack(alignment: .leading) {
          SkeletonView(84, 14)
          SkeletonView(146, 10)
        }
        Spacer()
      }
      HStack {
        SkeletonView(68, 11)
        SkeletonView(68, 11)
        Spacer()
      }
      Spacer()
    }
  }
}
