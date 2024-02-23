//
//  BusinessHomeAvatar.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import SwiftUI

struct BusinessHomeAvatar: View {
  let url: String

  var body: some View {
    AvatarView(
      imageUrl: url,
      size: BusinessAvatarConstants.size
    )
  }
}
