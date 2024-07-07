//
//  SelectedPhotoPage.swift
//  locarie
//
//  Created by qiuty on 16/04/2024.
//

import SwiftUI
import UIKit

struct SelectedPhotoPage: View {
  @ObservedObject var vm: PhotoViewModel

  @State var curIndex = 0

  var body: some View {
    VStack {
      NavigationBar("Selected photo \(curIndex + 1)")

      TabView(selection: $curIndex) {
        ForEach(vm.attachments.indices, id: \.self) { i in
          Image(uiImage: UIImage(data: vm.attachments[i].data) ?? UIImage())
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            .padding(.horizontal)
            .tag(i)
        }
      }
      .tabViewStyle(.page(indexDisplayMode: .always))

      HStack(spacing: Constants.indicatorHSpacing) {
        ForEach(vm.attachments.indices, id: \.self) { i in
          Image(systemName: "circle.fill")
            .font(.system(size: Constants.indicatorSize))
            .foregroundStyle(
              curIndex == i ? LocarieColor.primary : LocarieColor.primary.opacity(Constants.indicatorOpacity)
            )
        }
      }
    }
  }
}

private enum Constants {
  static let aspectRadio: CGFloat = 4 / 3
  static let cornerRadius: CGFloat = 16
  static let indicatorOpacity: CGFloat = 0.2
  static let indicatorHSpacing: CGFloat = 6
  static let indicatorSize: CGFloat = 9
  static let trashIconSize: CGFloat = 28
}
