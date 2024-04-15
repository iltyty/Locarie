//
//  AvatarBuilder.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import Foundation
import SwiftUI

func defaultAvatar(size: CGFloat) -> some View {
  Image("DefaultBusinessAvatar")
    .resizable()
    .scaledToFit()
    .frame(width: size, height: size)
}
