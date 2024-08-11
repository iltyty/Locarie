//
//  BusinessImagesEditPage.swift
//  locarie
//
//  Created by qiuty on 15/04/2024.
//

import Kingfisher
import PhotosUI
import SwiftUI

struct BusinessImagesEditPage: View {
  @ObservedObject private var cacheVM = LocalCacheViewModel.shared
  @StateObject private var imageVM = BusinessImagesViewModel()
  @State private var loading = false
  @State private var presentingAlert = false

  var body: some View {
    VStack {
      NavigationBar("Edit business photos", right: saveButton, divider: true)
      VStack(alignment: .leading) {
        Spacer()
        Text("\(firstImageText) \(recommendText)")
          .padding(.bottom, 24)
        businessImages.padding(.bottom, 16)
        Text("Select up to 9 images.").fontWeight(.bold)
        Spacer()
      }
      .padding(.horizontal, 16)
    }
    .alert("Upload success", isPresented: $presentingAlert) {
      Button("OK") {}
    }
    .loadingIndicator(loading: $loading)
    .onAppear {
      imageVM.get(userId: cacheVM.getUserId())
    }
    .onChange(of: imageVM.existedImageData) { data in
      if data.count == imageVM.existedImageUrls.count {
        loading = false
      }
    }
    .onReceive(imageVM.$state) { state in
      switch state {
      case .getFinished:
        Task {
          await imageVM.loader.loadExistedImageData(on: imageVM)
        }
      case .uploadFinished:
        loading = false
        presentingAlert = true
        for url in imageVM.imageUrls {
          ImageCache.default.removeImage(forKey: url)
        }
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
      maxSelectionCount: Constants.maxImageCount - imageVM.existedImageUrls.count,
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
    let urls = imageVM.existedImageUrls
    let data = imageVM.existedImageData
    ForEach(Array(urls.enumerated()), id: \.element) { url in
      ZStack(alignment: .topTrailing) {
        BusinessImageView(
          url: url.element,
          data: data.count > url.offset ? data[url.offset] : nil,
          loadFromData: true,
          size: Constants.imageSize,
          bordered: url.offset == 0
        )
        ImageDeleteButton()
          .onTapGesture {
            imageVM.existedImageUrls.remove(at: url.offset)
            if imageVM.existedImageData.count > url.offset {
              imageVM.existedImageData.remove(at: url.offset)
            }
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
        ImageDeleteButton()
          .onTapGesture {
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
        .frame(size: Constants.imageSize)
      Image("DefaultImage")
        .resizable()
        .scaledToFit()
        .frame(size: Constants.defaultImageIconSize)
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
