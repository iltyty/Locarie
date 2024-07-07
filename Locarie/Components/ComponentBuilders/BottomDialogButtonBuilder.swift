//
//  BottomDialogButtonBuilder.swift
//  locarie
//
//  Created by qiuty on 20/06/2024.
//

import SwiftUI

func bottomDialogButtonBuilder(_ title: String, action: @escaping () -> Void) -> some View {
  Text(title)
    .fontWeight(.bold)
    .frame(height: 48)
    .frame(maxWidth: .infinity)
    .background {
      RoundedRectangle(cornerRadius: 30).fill(.white).frame(maxWidth: .infinity)
    }
    .onTapGesture {
      action()
    }
}
