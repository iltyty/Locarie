//
//  PostCover.swift
//  locarie
//
//  Created by qiuty on 21/02/2024.
//
import CoreLocation
import Kingfisher
import SwiftUI

struct PostCover: View {
  let imageUrls: [String]
  @Binding var isPresenting: Bool

  @State private var curIndex = 0
  private let cacheVM = LocalCacheViewModel.shared
  private let locationManager = LocationManager()

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Image(systemName: "multiply")
        .resizable()
        .scaledToFit()
        .frame(size: 18)
        .contentShape(Rectangle())
        .padding(.horizontal, 24)
        .onTapGesture { isPresenting = false }
      
      Spacer()
      
      TabView(selection: $curIndex) {
        ForEach(imageUrls, id: \.self) { url in
          KFImage(URL(string: url))
            .placeholder {
              Rectangle().fill(LocarieColor.greyMedium)
            }
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .tag(url)
        }
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
      
      Spacer()

      HStack(spacing: 5) {
        Spacer()
        ForEach(imageUrls.indices, id: \.self) { i in
          Image(systemName: "circle.fill")
            .font(.system(size: 6))
            .foregroundStyle(
              curIndex == i ? LocarieColor.primary : LocarieColor.primary.opacity(0.2)
            )
        }
        Spacer()
      }
      .padding(.bottom, 60)
    }
    .background(.ultraThinMaterial.opacity(CoverCommonConstants.backgroundOpacity))
  }
}
