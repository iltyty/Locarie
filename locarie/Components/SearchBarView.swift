//
//  SearchBarView.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import SwiftUI

struct SearchBarView: View {
    @State var text = ""
    var title = "Explore"
    var isDisabled = false

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .padding([.leading])
                .padding([.trailing], Constants.iconPadding)

            TextField(title, text: $text)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .disabled(isDisabled)
        }
        .background(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(.background)
                .frame(height: Constants.height)
                .shadow(color: .gray, radius: 2)
        )
        .padding(Constants.padding)
    }

    private enum Constants {
        static let height: CGFloat = 50.0
        static let padding: CGFloat = 20.0
        static let iconPadding: CGFloat = 10.0
        static let cornerRadius: CGFloat = 25.0
    }
}

#Preview {
    let text = ""
    return SearchBarView(text: text)
}
