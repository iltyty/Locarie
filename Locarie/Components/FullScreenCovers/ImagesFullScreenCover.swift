//
//  ImageFullScreenCover.swift
//  locarie
//
//  Created by qiuty on 21/02/2024.
//
import CoreLocation
import Kingfisher
import SwiftUI

struct ImagesFullScreenCover: View {
  let imageUrls: [String]
  @Binding var isPresenting: Bool

  @State private var curIndex = 0
  private let cacheVM = LocalCacheViewModel.shared

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Image(systemName: "multiply")
        .resizable()
        .scaledToFit()
        .frame(size: 18)
        .contentShape(Rectangle())
        .padding(.top, 19)
        .padding(.horizontal, 24)
        .onTapGesture { isPresenting = false }
      
      Spacer()
      
      TabView(selection: $curIndex) {
        ForEach(imageUrls.indices, id: \.self) { i in
          KFImage(URL(string: imageUrls[i]))
            .placeholder {
              Rectangle().fill(LocarieColor.greyMedium)
            }
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .tag(i)
        }
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
      .padding(.vertical, 8)
      
      Spacer()
      
      HStack(spacing: 5) {
        Spacer()
        ForEach(imageUrls.indices, id: \.self) { i in
          Image(systemName: "circle.fill")
            .font(.system(size: 6))
            .foregroundStyle(
              curIndex == i ? Color.white : LocarieColor.greyMedium
            )
        }
        Spacer()
      }
      .padding(.bottom, 60)
    }
    .background(.ultraThinMaterial.opacity(CoverCommonConstants.backgroundOpacity))
  }
}
