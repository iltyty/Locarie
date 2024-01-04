//
//  PrimaryColorFormItemBuilder.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import Foundation
import SwiftUI

func primaryColorFormItemBuilder(text: String) -> some View {
  primaryColorFormItemBuilder(label: Text(text))
}

func primaryColorFormItemBuilder(label: some View) -> some View {
  label
    .frame(maxWidth: .infinity)
    .foregroundStyle(.white)
    .fontWeight(.bold)
    .background(formItemBackground(Color.locariePrimary))
    .frame(height: ComponentBuilderConstants.formItemHeight)
}
