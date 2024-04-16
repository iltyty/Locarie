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
    VStack {
      NavigationBar("Edit business photos", right: saveButton, divider: true)
      Spacer()
      businessImages
      Text("Select up to 9 images that best showcase your business.")
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
  var deleteButton: some View {
    ZStack {
      Circle()
        .fill(.background)
        .frame(width: Constants.deleteButtonSize, height: Constants.deleteButtonSize)
        .shadow(radius: Constants.deleteButtonShadowRadius)
      Image(systemName: "xmark")
        .font(.system(size: Constants.deleteButtonIconSize))
        .foregroundStyle(.black)
        .frame(width: Constants.deleteButtonIconSize, height: Constants.deleteButtonIconSize)
    }
    .offset(x: Constants.deleteButtonOffset, y: -Constants.deleteButtonOffset)
  }

  @ViewBuilder
  var existedImages: some View {
    ForEach(imageVM.existedImageUrls, id: \.self) { url in
      ZStack(alignment: .topTrailing) {
        BusinessImageView(
          url: URL(string: url),
          size: Constants.imageSize,
          bordered: url == imageVM.existedImageUrls[0]
        )
        deleteButton.onTapGesture {
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
        deleteButton.onTapGesture {
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

  static let deleteButtonOffset: CGFloat = 5
  static let deleteButtonShadowRadius: CGFloat = 2
  static let deleteButtonSize: CGFloat = 24
  static let deleteButtonIconSize: CGFloat = 12
}

#Preview {
  BusinessImagesEditPage()
}
