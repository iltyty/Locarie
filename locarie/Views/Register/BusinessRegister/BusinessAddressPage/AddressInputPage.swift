//
//  AddressInputPage.swift
//  locarie
//
//  Created by qiuty on 06/07/2024.
//

import SwiftUI

struct AddressInputPage: View {
  @Binding var address: String
  @Binding var neighborhood: String

  var body: some View {
    VStack(spacing: 24) {
      Text("Your Business Address").fontWeight(.bold)
      VStack(spacing: 16) {
        TextEditFormItemWithBlockTitle(title: "Neighborhood", hint: "Neighborhood", text: $neighborhood)
        TextEditFormItemWithBlockTitle(title: "Street Address", hint: "Street Address", text: $address)
      }
      Spacer()
    }
  }
}
