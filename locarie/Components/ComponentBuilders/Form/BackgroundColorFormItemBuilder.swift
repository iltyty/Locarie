//
//  BackgroundColorFormItemBuilder.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import Foundation
import SwiftUI

func backgroundColorFormItemBuilder(text: String) -> some View {
  backgroundColorFormItemBuilder(label: Text(text))
}

func backgroundColorFormItemBuilder(label: some View) -> some View {
  label
    .frame(maxWidth: .infinity)
    .background(formItemBackground(.background))
    .padding(.horizontal)
    .frame(height: ComponentBuilderConstants.formItemHeight)
}
