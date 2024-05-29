//
//  BusinessImagesEditPage.swift
//  locarie
//
//  Created by qiuty on 15/04/2024.
//

import PhotosUI
import SwiftUI

struct BusinessImagesEditPage: View {
  @ObservedObject private var cacheVM = LocalCacheViewModel.shared
  @StateObject private var imageVM = BusinessImagesViewModel()
  @State private var loading = false
  @State private var presentingAlert = false

  var body: some View {
    VStack(alignment: .leading) {
      NavigationBar("Edit business photos", right: saveButton, divider: true)
      Spacer()
      Text("\(firstImageText) \(recommendText)").padding(.horizontal)
      businessImages
      Text("Select up to 9 images.").fontWeight(.bold).padding(.horizontal)
      Spacer()
    }
    .alert("Upload success", isPresented: $presentingAlert) {
      Button("OK") {}
    }
    .loadingIndicator(loading: $loading)
    .onAppear {
      imageVM.get(userId: cacheVM.getUserId())
    }
    .onReceive(imageVM.$state) { state in
      switch state {
      case .uploadFinished:
        loading = false
        presentingAlert = true
      case .loading:
        loading = true
      default:
        loading = false
      }
    }
  }

  private var firstImageText: Text {
    Text("First Image: ")
      .fontWeight(.bold)
      .foregroundColor(LocarieColor.primary)
  }

  private var recommendText: Text {
    if #available(iOS 17.0, *) {
      Text("We recommend using a storefront image or one that best capture your business!")
        .foregroundStyle(LocarieColor.greyDark)
    } else {
      Text("We recommend using a storefront image or one that best capture your business!")
        .foregroundColor(LocarieColor.greyDark)
    }
  }

  private var businessImages: some View {
    PhotosPicker(
      selection: $imageVM.photoVM.selection,
      maxSelectionCount: defaultImagesCount,
      matching: .images,
      photoLibrary: .shared()
    ) {
      LazyVGrid(columns: imageColumns) {
        existedImages
        selectedImages
        defaultImages
      }
    }
    .buttonStyle(.plain)
  }

  private var imageColumns: [GridItem] {
    [
      GridItem(.fixed(Constants.imageSize)),
      GridItem(.fixed(Constants.imageSize)),
      GridItem(.fixed(Constants.imageSize)),
    ]
  }

  private var saveButton: some View {
    Text("Save")
      .fontWeight(.bold)
      .foregroundStyle(LocarieColor.primary)
      .onTapGesture {
        imageVM.upload(userId: cacheVM.getUserId())
      }
  }
}

private extension BusinessImagesEditPage {
  @ViewBuilder
  var existedImages: some View {
    ForEach(imageVM.existedImageUrls, id: \.self) { url in
      ZStack(alignment: .topTrailing) {
        BusinessImageView(
          url: URL(string: url),
          size: Constants.imageSize,
          bordered: url == imageVM.existedImageUrls[0]
        )
        ImageDeleteButton().onTapGesture {
          imageVM.existedImageUrls.removeAll { $0 == url }
        }
      }
    }
  }

  @ViewBuilder
  var selectedImages: some View {
    let attachments = imageVM.photoVM.attachments
    ForEach(attachments) { attachment in
      ZStack(alignment: .topTrailing) {
        ImageAttachmentView(
          width: Constants.imageSize,
          height: Constants.imageSize,
          attachment: attachment
        )
        .overlay {
          if imageVM.existedImageUrls.isEmpty, attachment.id == attachments[0].id {
            imageStroke
          } else {
            EmptyView()
          }
        }
        ImageDeleteButton().onTapGesture {
          let index = attachments.firstIndex { $0.id == attachment.id }!
          imageVM.photoVM.selection.remove(at: index)
          imageVM.objectWillChange.send()
        }
      }
    }
  }

  var imageStroke: some View {
    RoundedRectangle(cornerRadius: Constants.imageCornerRadius)
      .strokeBorder(LocarieColor.primary, style: .init(lineWidth: Constants.firstImageStrokeWidth))
  }

  var defaultImages: some View {
    ForEach(0 ..< defaultImagesCount, id: \.self) { i in
      ZStack {
        defaultImage
        if defaultImagesCount == Constants.maxImageCount, i == 0 {
          imageStroke
        }
      }
    }
  }

  var defaultImagesCount: Int {
    Constants.maxImageCount - imageVM.existedImageUrls.count - imageVM.photoVM.attachments.count
  }

  var defaultImage: some View {
    ZStack {
      RoundedRectangle(cornerRadius: Constants.imageCornerRadius)
        .fill(LocarieColor.greyMedium)
        .frame(width: Constants.imageSize, height: Constants.imageSize)
      Image("DefaultImage")
        .resizable()
        .scaledToFit()
        .frame(width: Constants.defaultImageIconSize, height: Constants.defaultImageIconSize)
    }
  }
}

private enum Constants {
  static let maxImageCount = 9
  static let firstImageStrokeWidth: CGFloat = 3
  static let imageSize: CGFloat = 114
  static let imageCornerRadius: CGFloat = 16
  static let defaultImageIconSize: CGFloat = 28
}

#Preview {
  BusinessImagesEditPage()
}
